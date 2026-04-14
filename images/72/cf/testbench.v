`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg en;
    reg rst;
    reg up;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .rst(rst),
        .up(up),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        en = 0;
        forever #5 en = ~en;
    end

        task reset_dut;

        begin
            rst = 1;
            up = 0;


            @(negedge en);
            #2 rst = 0;
            $display("DUT Reset to 0");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Counting Up", test_num);
            reset_dut();
            up = 1;

            repeat (5) @(posedge en);
            #2 #1;
 check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Counting Down from Zero", test_num);
            reset_dut();
            up = 0;

            @(posedge en);
            #2 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Up Wrap-around (15 -> 0)", test_num);
            reset_dut();
            up = 1;

            repeat (16) @(posedge en);
            #2 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Direction Change (Up then Down)", test_num);
            reset_dut();
            up = 1;
            repeat (10) @(posedge en);
            @(negedge en) up = 0;
            repeat (3) @(posedge en);
            #2 #1;
 check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Asynchronous Reset during operation", test_num);
            reset_dut();
            up = 1;
            repeat (4) @(posedge en);
            #2 rst = 1;
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,en, rst, up, out);
    end

endmodule

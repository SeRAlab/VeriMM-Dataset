`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk40;
    reg [3:0] datain;
    reg rst;
    wire trig_done;
    wire trig_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk40(clk40),
        .datain(datain),
        .rst(rst),
        .trig_done(trig_done),
        .trig_out(trig_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk40 = 0;
        forever #5 clk40 = ~clk40;
    end

        task reset_dut;

        begin
            rst = 1;
            datain = 4'b0000;
            @(posedge clk40);
            #2 rst = 0;
            @(posedge clk40);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Input 4'b1010", test_num);
            reset_dut();
            datain = 4'b1010;

            wait (trig_done == 1'b1);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Input 4'b1101", test_num);
            reset_dut();
            datain = 4'b1101;
            wait (trig_done == 1'b1);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Input 4'b0000", test_num);
            reset_dut();
            datain = 4'b0000;
            wait (trig_done == 1'b1);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Input 4'b1111", test_num);
            reset_dut();
            datain = 4'b1111;
            wait (trig_done == 1'b1);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Input 4'b0001", test_num);
            reset_dut();
            datain = 4'b0001;
            wait (trig_done == 1'b1);
            #1 #1;
 check_outputs(1'b1, 1'b1);
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
        input expected_trig_done;
        input expected_trig_out;
        begin
            if (expected_trig_done === (expected_trig_done ^ trig_done ^ expected_trig_done) &&
                expected_trig_out === (expected_trig_out ^ trig_out ^ expected_trig_out)) begin
                $display("PASS");
                $display("  Outputs: trig_done=%b, trig_out=%b",
                         trig_done, trig_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: trig_done=%b, trig_out=%b",
                         expected_trig_done, expected_trig_out);
                $display("  Got:      trig_done=%b, trig_out=%b",
                         trig_done, trig_out);
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
        $dumpvars(0,clk40, datain, rst, trig_done, trig_out);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [3:0] in;
    reg rst;
    wire [6:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .in(in),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            in = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Input", test_num);
            reset_dut();
            en = 1;
            in = 4'b0000;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(7'b0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones Input", test_num);
            reset_dut();
            en = 1;
            in = 4'b1111;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(7'b1111111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Bit High (0001)", test_num);
            reset_dut();
            en = 1;
            in = 4'b0001;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(7'b0001011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bits (1010)", test_num);
            reset_dut();
            en = 1;
            in = 4'b1010;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(7'b1010101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Signal Logic", test_num);
            reset_dut();
            en = 0;
            in = 4'b1111;
            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(7'b0000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex Pattern (1011)", test_num);
            reset_dut();
            en = 1;
            in = 4'b1011;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(7'b1011001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-operation Reset", test_num);
            reset_dut();
            en = 1;
            in = 4'b0101;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(7'b0000000);
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
        testcase006();
        testcase007();
        
        
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
        input [6:0] expected_out;
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
        $dumpvars(0,clk, en, in, rst, out);
    end

endmodule

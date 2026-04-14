`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RST;
    reg UP_DOWN;
    reg clk;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RST(RST),
        .UP_DOWN(UP_DOWN),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RST = 1;
            UP_DOWN = 0;
            #15;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Counting Up", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Up Counter Wrap-around", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Down Counter Wrap-around", test_num);
            reset_dut();
            UP_DOWN = 0;
            repeat(1) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Mode Switching (Up then Down)", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(5) @(posedge clk);
            UP_DOWN = 0;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Asynchronous Reset during operation", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(4) @(posedge clk);
            #3;
            RST = 1;
            #2;
            #1;

            check_outputs(3'd0);
            RST = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Counting Down 4 times", test_num);
            reset_dut();
            UP_DOWN = 0;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd4);
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
        input [2:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,RST, UP_DOWN, clk, Q);
    end

endmodule

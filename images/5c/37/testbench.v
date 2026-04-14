`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] left;
    reg [5:0] right;
    wire [2:0] exp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .left(left),
        .right(right),
        .exp(exp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            left = 6'b0;
            right = 6'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            left  = 6'b000_000;
            right = 6'b000_000;
            @(posedge clk);
            #1;
            $display("Test %0d: Zero Inputs", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            left  = 6'b000_010;
            right = 6'b000_001;
            @(posedge clk);
            #1;
            $display("Test %0d: Small Exponents (2 + 1)", test_num);
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            left  = 6'b000_100;
            right = 6'b000_011;
            @(posedge clk);
            #1;
            $display("Test %0d: Boundary Sum (4 + 3)", test_num);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            left  = 6'b000_101;
            right = 6'b000_100;
            @(posedge clk);
            #1;
            $display("Test %0d: Overflow Wrap (5 + 4 = 9 -> 1)", test_num);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            left  = 6'b111_010;
            right = 6'b101_010;
            @(posedge clk);
            #1;
            $display("Test %0d: Upper Bits Masking", test_num);
            #1;

            check_outputs(3'b100);
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
        input [2:0] expected_exp;
        begin
            if (expected_exp === (expected_exp ^ exp ^ expected_exp)) begin
                $display("PASS");
                $display("  Outputs: exp=%h",
                         exp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exp=%h",
                         expected_exp);
                $display("  Got:      exp=%h",
                         exp);
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
        $dumpvars(0,clk, left, right, exp);
    end

endmodule

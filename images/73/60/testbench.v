`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg clk;
    reg rst_n;
    wire [3:0] Q;
    wire oversuber;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q),
        .oversuber(oversuber)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            EN = 0;
            rst_n = 0;
            @(posedge clk);
            #2;
            rst_n = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State...", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying start from 9 when enabled...", test_num);
            reset_dut();
            EN = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd9, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying decrement from 9 to 8...", test_num);
            reset_dut();
            EN = 1;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(4'd8, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying counter holds when EN=0...", test_num);
            reset_dut();
            EN = 1;
            repeat(5) @(posedge clk);
            #2;
            EN = 0;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying countdown to zero and oversuber...", test_num);
            reset_dut();
            EN = 1;

            repeat(10) @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying saturation at zero (no further decrement)...", test_num);
            reset_dut();
            EN = 1;
            repeat(15) @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0, 1'b1);
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
        input [3:0] expected_Q;
        input expected_oversuber;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_oversuber === (expected_oversuber ^ oversuber ^ expected_oversuber)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, oversuber=%b",
                         Q, oversuber);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, oversuber=%b",
                         expected_Q, expected_oversuber);
                $display("  Got:      Q=%h, oversuber=%b",
                         Q, oversuber);
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
        $dumpvars(0,EN, clk, rst_n, Q, oversuber);
    end

endmodule

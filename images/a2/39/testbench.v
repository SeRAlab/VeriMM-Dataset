`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [2:0] q1;
    wire [1:0] q2;
    wire [1:0] q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .q1(q1),
        .q2(q2),
        .q3(q3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(3'd0, 2'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 2'd0, 2'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable = 1;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 2'd1, 2'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd4, 2'd0, 2'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 1;
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 2'd0, 2'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enable = 1;
            repeat(128) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 2'd0, 2'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            enable = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2, 2'd1, 2'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            enable = 1;
            repeat(127) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd7, 2'd3, 2'd3);
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
        testcase008();
        
        
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
        input [2:0] expected_q1;
        input [1:0] expected_q2;
        input [1:0] expected_q3;
        begin
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2) &&
                expected_q3 === (expected_q3 ^ q3 ^ expected_q3)) begin
                $display("PASS");
                $display("  Outputs: q1=%h, q2=%h, q3=%h",
                         q1, q2, q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h, q2=%h, q3=%h",
                         expected_q1, expected_q2, expected_q3);
                $display("  Got:      q1=%h, q2=%h, q3=%h",
                         q1, q2, q3);
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
        $dumpvars(0,clk, enable, reset, q1, q2, q3);
    end

endmodule

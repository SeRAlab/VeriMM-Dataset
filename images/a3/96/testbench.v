`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg reset;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            #10;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task run_multiplication;

        input [3:0] in_A;
        input [3:0] in_B;
        begin
            A = in_A;
            B = in_B;

            repeat (5) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: 0 * 0");
            reset_dut();
            run_multiplication(4'd0, 4'd0);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: 1 * 1");
            reset_dut();
            run_multiplication(4'd1, 4'd1);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: 15 * 15");
            reset_dut();
            run_multiplication(4'd15, 4'd15);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: 10 * 0");
            reset_dut();
            run_multiplication(4'd10, 4'd0);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: 0 * 7");
            reset_dut();
            run_multiplication(4'd0, 4'd7);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: 3 * 7");
            reset_dut();
            run_multiplication(4'd3, 4'd7);
            #1;

            check_outputs(8'd21);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: 12 * 5");
            reset_dut();
            run_multiplication(4'd12, 4'd5);
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: 4 * 2");
            reset_dut();
            run_multiplication(4'd4, 4'd2);
            #1;

            check_outputs(8'd8);
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
        input [7:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,A, B, clk, reset, Y);
    end

endmodule

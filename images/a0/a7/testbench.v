`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg ready;
    reg rst_n;
    wire [7:0] quotient;
    wire [7:0] remainder;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .ready(ready),
        .rst_n(rst_n),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            A = 0;
            B = 0;
            ready = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task run_division;

        input [7:0] in_A;
        input [7:0] in_B;
        begin
            @(posedge clk);
            #1;
            A = in_A;
            B = in_B;
            ready = 1;
            @(posedge clk);
            #1;
            ready = 0;



            fork : timeout_block
                begin
                    wait(valid === 1'b1);
                end
                begin
                    repeat(100) @(posedge clk);
                    $display("Timeout waiting for valid signal!");
                end
            join_any
            disable timeout_block;


            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase001: Normal Division (100 / 10)");
            reset_dut();
            run_division(8'd100, 8'd10);
            #1;

            check_outputs(8'd10, 8'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Division with Remainder (25 / 7)");
            reset_dut();
            run_division(8'd25, 8'd7);
            #1;

            check_outputs(8'd3, 8'd4, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Divide by Zero");
            reset_dut();
            run_division(8'd50, 8'd0);
            #1;

            check_outputs(8'd0, 8'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Dividend smaller than Divisor (5 / 12)");
            reset_dut();
            run_division(8'd5, 8'd12);
            #1;

            check_outputs(8'd0, 8'd5, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Maximum Dividend (255 / 2)");
            reset_dut();
            run_division(8'd255, 8'd2);
            #1;

            check_outputs(8'd127, 8'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Dividend equals Divisor (128 / 128)");
            reset_dut();
            run_division(8'd128, 8'd128);
            #1;

            check_outputs(8'd1, 8'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase007: Division by 1 (42 / 1)");
            reset_dut();
            run_division(8'd42, 8'd1);
            #1;

            check_outputs(8'd42, 8'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase008: Zero Dividend (0 / 15)");
            reset_dut();
            run_division(8'd0, 8'd15);
            #1;

            check_outputs(8'd0, 8'd0, 1'b1);
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
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
        input expected_valid;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h, valid=%b",
                         expected_quotient, expected_remainder, expected_valid);
                $display("  Got:      quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
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
        $dumpvars(0,A, B, clk, ready, rst_n, quotient, remainder, valid);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] DIVIDEND;
    reg [7:0] DIVISOR;
    reg clk;
    wire [7:0] QUOTIENT;
    wire [7:0] REMAINDER;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIVIDEND(DIVIDEND),
        .DIVISOR(DIVISOR),
        .clk(clk),
        .QUOTIENT(QUOTIENT),
        .REMAINDER(REMAINDER)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DIVIDEND = 8'b0;
            DIVISOR = 8'b0;



            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Simple Division (20 / 5)", test_num);
            DIVIDEND = 8'd20;
            DIVISOR = 8'd5;

            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd4, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Division with Remainder (21 / 4)", test_num);
            DIVIDEND = 8'd21;
            DIVISOR = 8'd4;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd5, 8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Dividend < Divisor (7 / 10)", test_num);
            DIVIDEND = 8'd7;
            DIVISOR = 8'd10;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Max Dividend by 1 (255 / 1)", test_num);
            DIVIDEND = 8'd255;
            DIVISOR = 8'd1;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd255, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Division by self (255 / 255)", test_num);
            DIVIDEND = 8'd255;
            DIVISOR = 8'd255;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd1, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Large Dividend with Remainder (255 / 10)", test_num);
            DIVIDEND = 8'd255;
            DIVISOR = 8'd10;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd25; 8'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: Zero Dividend (0 / 50)", test_num);
            DIVIDEND = 8'd0;
            DIVISOR = 8'd50;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Test %0d: Power of Two Division (128 / 2)", test_num);
            DIVIDEND = 8'd128;
            DIVISOR = 8'd2;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd64, 8'd0);
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
        input [7:0] expected_QUOTIENT;
        input [7:0] expected_REMAINDER;
        begin
            if (expected_QUOTIENT === (expected_QUOTIENT ^ QUOTIENT ^ expected_QUOTIENT) &&
                expected_REMAINDER === (expected_REMAINDER ^ REMAINDER ^ expected_REMAINDER)) begin
                $display("PASS");
                $display("  Outputs: QUOTIENT=%h, REMAINDER=%h",
                         QUOTIENT, REMAINDER);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: QUOTIENT=%h, REMAINDER=%h",
                         expected_QUOTIENT, expected_REMAINDER);
                $display("  Got:      QUOTIENT=%h, REMAINDER=%h",
                         QUOTIENT, REMAINDER);
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
        $dumpvars(0,DIVIDEND, DIVISOR, clk, QUOTIENT, REMAINDER);
    end

endmodule

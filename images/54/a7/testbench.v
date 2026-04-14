`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dividend;
    reg [15:0] divisor;
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: Positive Dividend / Positive Divisor (20 / 4)", test_num);
        dividend = 16'd20; divisor = 16'd4;
        #1;

        check_outputs(16'd5, 16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Positive with Remainder (25 / 7)", test_num);
        dividend = 16'd25; divisor = 16'd7;
        #1;

        check_outputs(16'd3, 16'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Negative Dividend / Positive Divisor (-25 / 7)", test_num);
        dividend = -16'd25; divisor = 16'd7;
        #1;

        check_outputs(-16'd3, -16'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Positive Dividend / Negative Divisor (25 / -7)", test_num);
        dividend = 16'd25; divisor = -16'd7;
        #1;

        check_outputs(-16'd3, 16'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Negative Dividend / Negative Divisor (-25 / -7)", test_num);
        dividend = -16'd25; divisor = -16'd7;
        #1;

        check_outputs(16'd3, -16'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Division by Zero (50 / 0)", test_num);
        dividend = 16'd50; divisor = 16'd0;
        #1;

        check_outputs(16'd0, 16'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest %0d: Zero Dividend (0 / 15)", test_num);
        dividend = 16'd0; divisor = 16'd15;
        #1;

        check_outputs(16'd0, 16'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest %0d: Divide by 1 (123 / 1)", test_num);
        dividend = 16'd123; divisor = 16'd1;
        #1;

        check_outputs(16'd123, 16'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest %0d: Divide by -1 (123 / -1)", test_num);
        dividend = 16'd123; divisor = -16'd1;
        #1;

        check_outputs(-16'd123, 16'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest %0d: Large Negative Division (-32768 / 2)", test_num);
        dividend = -16'd32768; divisor = 16'd2;
        #1;

        check_outputs(-16'd16384, 16'd0);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_quotient;
        input [15:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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

endmodule

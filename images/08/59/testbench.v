`timescale 1ns/1ps

module SRT_Divider_tb;

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
    SRT_Divider dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Divide by Zero (1234 / 0)", test_num);
            dividend = 16'h1234;
            divisor  = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Simple Exact Division (20 / 5)", test_num);
            dividend = 16'd20;
            divisor  = 16'd5;
            #1;

            check_outputs(16'd4, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Simple Division with Remainder (17 / 3)", test_num);
            dividend = 16'd17;
            divisor  = 16'd3;
            #1;

            check_outputs(16'd5, 16'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Dividend < Divisor (5 / 10)", test_num);
            dividend = 16'd5;
            divisor  = 16'd10;
            #1;

            check_outputs(16'd0, 16'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Dividend is Zero (0 / 55)", test_num);
            dividend = 16'd0;
            divisor  = 16'd55;
            #1;

            check_outputs(16'd0, 16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Max Dividend (65535 / 2)", test_num);
            dividend = 16'hFFFF;
            divisor  = 16'd2;
            #1;

            check_outputs(16'h7FFF, 16'h0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Max Dividend / Max Divisor (65535 / 65535)", test_num);
            dividend = 16'hFFFF;
            divisor  = 16'hFFFF;
            #1;

            check_outputs(16'h0001, 16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Powers of Two (1024 / 32)", test_num);
            dividend = 16'd1024;
            divisor  = 16'd32;
            #1;

            check_outputs(16'd32, 16'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Large Values (43981 / 4660)", test_num);
            dividend = 16'hABCD;
            divisor  = 16'h1234;
            #1;

            check_outputs(16'h0009, 16'h07F9);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Division by 1 (42 / 1)", test_num);
            dividend = 16'd42;
            divisor  = 16'd1;
            #1;

            check_outputs(16'd42, 16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRT_Divider Testbench");
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

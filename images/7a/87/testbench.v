`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dividend;
    reg [31:0] divisor;
    wire [31:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dividend(dividend),
        .divisor(divisor),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = 1;
            dividend = 32'd500;
            divisor = 32'd0;
            $display("Testcase %0d: Division by zero (500 %% 0)", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            dividend = 32'd10;
            divisor = 32'd3;
            $display("Testcase %0d: Simple division (10 %% 3)", test_num);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            dividend = 32'd5;
            divisor = 32'd10;
            $display("Testcase %0d: Dividend smaller than divisor (5 %% 10)", test_num);
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            dividend = 32'd100;
            divisor = 32'd10;
            $display("Testcase %0d: Dividend is multiple of divisor (100 %% 10)", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            dividend = 32'd100;
            divisor = 32'd100;
            $display("Testcase %0d: Dividend equals divisor (100 %% 100)", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            dividend = 32'hFFFFFFFF;
            divisor = 32'd10;
            $display("Testcase %0d: Large dividend (4294967295 %% 10)", test_num);
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            dividend = 32'd0;
            divisor = 32'd50;
            $display("Testcase %0d: Dividend is zero (0 %% 50)", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            dividend = 32'd12345678;
            divisor = 32'd1234;
            $display("Testcase %0d: Arbitrary division (12345678 %% 1234)", test_num);
            #1;

            check_outputs(32'd610);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            dividend = 32'hFFFFFFFE;
            divisor = 32'hFFFFFFFF;
            $display("Testcase %0d: Large divisor (Max-1 %% Max)", test_num);
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            dividend = 32'd1048576;
            divisor = 32'd1024;
            $display("Testcase %0d: Power of 2 division (2^20 %% 2^10)", test_num);
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: remainder=%h",
                         remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: remainder=%h",
                         expected_remainder);
                $display("  Got:      remainder=%h",
                         remainder);
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

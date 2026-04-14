`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] denominator;
    reg [7:0] numerator;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .denominator(denominator),
        .numerator(numerator),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = 1;
        numerator = 8'd15;
        denominator = 8'd0;
        $display("Test %0d: Denominator is zero (15 %% 0)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        numerator = 8'd5;
        denominator = 8'd10;
        $display("Test %0d: Numerator less than denominator (5 %% 10)", test_num);
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        numerator = 8'd20;
        denominator = 8'd20;
        $display("Test %0d: Numerator equals denominator (20 %% 20)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        numerator = 8'd10;
        denominator = 8'd3;
        $display("Test %0d: Standard division (10 %% 3)", test_num);
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        numerator = 8'd255;
        denominator = 8'd1;
        $display("Test %0d: Divide by one (255 %% 1)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        numerator = 8'd255;
        denominator = 8'd255;
        $display("Test %0d: Max values (255 %% 255)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        numerator = 8'd255;
        denominator = 8'd100;
        $display("Test %0d: Large numerator (255 %% 100)", test_num);
        #1;

        check_outputs(8'd55);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        numerator = 8'd0;
        denominator = 8'd50;
        $display("Test %0d: Zero numerator (0 %% 50)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        numerator = 8'd128;
        denominator = 8'd64;
        $display("Test %0d: Power of two multiple (128 %% 64)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        numerator = 8'd127;
        denominator = 8'd64;
        $display("Test %0d: Large remainder (127 %% 64)", test_num);
        #1;

        check_outputs(8'd63);
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
        input [7:0] expected_remainder;
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

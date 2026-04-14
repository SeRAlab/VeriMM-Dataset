`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] numerator;
    wire [2:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .numerator(numerator),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = 1;
        numerator = 6'd0;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        numerator = 6'd5;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd0, 4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        numerator = 6'd11;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd0, 4'd11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        numerator = 6'd12;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        numerator = 6'd20;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd1, 4'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        numerator = 6'd24;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd2, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        numerator = 6'd36;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd3, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        numerator = 6'd45;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd3, 4'd9);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        numerator = 6'd48;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd4, 4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        numerator = 6'd59;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd4, 4'd11);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        numerator = 6'd60;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd5, 4'd0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        numerator = 6'd63;
        $display("Testcase %03d: numerator = %d", test_num, numerator);
        #1;

        check_outputs(3'd5, 4'd3);
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
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_quotient;
        input [3:0] expected_remainder;
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

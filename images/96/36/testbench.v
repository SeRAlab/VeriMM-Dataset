`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] number;
    wire [15:0] abs_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .number(number),
        .abs_value(abs_value)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input zero (0)", test_num);
        number = 16'sd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Small positive integer (42)", test_num);
        number = 16'sd42;
        #1;

        check_outputs(16'd42);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Small negative integer (-42)", test_num);
        number = -16'sd42;
        #1;

        check_outputs(16'd42);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Maximum positive 16-bit signed integer (32767)", test_num);
        number = 16'sd32767;
        #1;

        check_outputs(16'd32767);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Negative equivalent of maximum positive (-32767)", test_num);
        number = -16'sd32767;
        #1;

        check_outputs(16'd32767);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input -1", test_num);
        number = -16'sd1;
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Most negative 16-bit signed integer (-32768)", test_num);

        number = 16'sh8000;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Random positive value (1234)", test_num);
        number = 16'sd1234;
        #1;

        check_outputs(16'd1234);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Random negative value (-5678)", test_num);
        number = -16'sd5678;
        #1;

        check_outputs(16'd5678);
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
        input [15:0] expected_abs_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_abs_value === (expected_abs_value ^ abs_value ^ expected_abs_value)) begin
                $display("PASS");
                $display("  Outputs: abs_value=%h",
                         abs_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: abs_value=%h",
                         expected_abs_value);
                $display("  Got:      abs_value=%h",
                         abs_value);
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

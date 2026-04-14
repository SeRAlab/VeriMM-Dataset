`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] num1;
    reg [3:0] num2;
    wire [3:0] larger_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num1(num1),
        .num2(num2),
        .larger_num(larger_num)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: num1 > num2", test_num);
            num1 = 4'd10;
            num2 = 4'd5;
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: num2 > num1", test_num);
            num1 = 4'd3;
            num2 = 4'd12;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Equality (mid-range)", test_num);
            num1 = 4'd7;
            num2 = 4'd7;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both Zero", test_num);
            num1 = 4'd0;
            num2 = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both Max (15)", test_num);
            num1 = 4'd15;
            num2 = 4'd15;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max vs Min", test_num);
            num1 = 4'd15;
            num2 = 4'd0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min vs Max", test_num);
            num1 = 4'd0;
            num2 = 4'd15;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive values", test_num);
            num1 = 4'd8;
            num2 = 4'd9;
            #1;

            check_outputs(4'd9);
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
        input [3:0] expected_larger_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_larger_num === (expected_larger_num ^ larger_num ^ expected_larger_num)) begin
                $display("PASS");
                $display("  Outputs: larger_num=%h",
                         larger_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: larger_num=%h",
                         expected_larger_num);
                $display("  Got:      larger_num=%h",
                         larger_num);
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

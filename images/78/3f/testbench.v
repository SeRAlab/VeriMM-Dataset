`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] num1;
    reg [7:0] num2;
    reg [7:0] num3;
    reg [7:0] num4;
    wire [7:0] min_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num1(num1),
        .num2(num2),
        .num3(num3),
        .num4(num4),
        .min_val(min_val)
    );
    task testcase001;

        begin
            test_num = 1;
            num1 = 8'd10; num2 = 8'd20; num3 = 8'd30; num4 = 8'd40;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            num1 = 8'd50; num2 = 8'd5; num3 = 8'd60; num4 = 8'd70;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            num1 = 8'd100; num2 = 8'd110; num3 = 8'd80; num4 = 8'd120;
            #1;

            check_outputs(8'd80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            num1 = 8'd200; num2 = 8'd210; num3 = 8'd220; num4 = 8'd150;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            num1 = 8'd42; num2 = 8'd42; num3 = 8'd42; num4 = 8'd42;
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            num1 = 8'd15; num2 = 8'd20; num3 = 8'd15; num4 = 8'd25;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            num1 = 8'd0; num2 = 8'd255; num3 = 8'd128; num4 = 8'd64;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            num1 = 8'd255; num2 = 8'd255; num3 = 8'd255; num4 = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            num1 = 8'd40; num2 = 8'd30; num3 = 8'd20; num4 = 8'd10;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            num1 = 8'd128; num2 = 8'd129; num3 = 8'd127; num4 = 8'd130;
            #1;

            check_outputs(8'd127);
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
        input [7:0] expected_min_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_min_val === (expected_min_val ^ min_val ^ expected_min_val)) begin
                $display("PASS");
                $display("  Outputs: min_val=%h",
                         min_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min_val=%h",
                         expected_min_val);
                $display("  Got:      min_val=%h",
                         min_val);
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

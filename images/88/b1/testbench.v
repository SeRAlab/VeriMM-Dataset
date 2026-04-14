`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [27:0] i_0;
    reg [27:0] i_1;
    reg [27:0] i_2;
    reg [27:0] i_3;
    wire [27:0] o_0;
    wire [27:0] o_1;
    wire [27:0] o_2;
    wire [27:0] o_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_0(i_0),
        .i_1(i_1),
        .i_2(i_2),
        .i_3(i_3),
        .o_0(o_0),
        .o_1(o_1),
        .o_2(o_2),
        .o_3(o_3)
    );
    task testcase001;

        begin
            test_num = 1;
            i_0 = 28'sd0;
            i_1 = 28'sd0;
            i_2 = 28'sd0;
            i_3 = 28'sd0;

            #1;


            check_outputs(28'sd0, 28'sd0, 28'sd0, 28'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            i_0 = 28'sd100;
            i_1 = 28'sd200;
            i_2 = 28'sd50;
            i_3 = 28'sd25;

            #1;


            check_outputs(28'sd125, 28'sd250, 28'sd150, 28'sd75);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            i_0 = 28'sd1000;
            i_1 = 28'sd1000;
            i_2 = 28'sd1000;
            i_3 = 28'sd1000;

            #1;


            check_outputs(28'sd2000, 28'sd2000, 28'sd0, 28'sd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            i_0 = 28'sd-10;
            i_1 = 28'sd-20;
            i_2 = 28'sd-30;
            i_3 = 28'sd-40;

            #1;


            check_outputs(28'sd-50, 28'sd-50, 28'sd10, 28'sd30);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            i_0 = 28'sd500;
            i_1 = 28'sd-500;
            i_2 = 28'sd500;
            i_3 = 28'sd-500;

            #1;


            check_outputs(28'sd0, 28'sd0, 28'sd-1000, 28'sd1000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            i_0 = 28'sd13421772;
            i_1 = 28'sd0;
            i_2 = 28'sd0;
            i_3 = 28'sd13421772;

            #1;


            check_outputs(28'sd26843544, 28'sd0, 28'sd0, 28'sd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            i_0 = 28'h7FFFFFF;
            i_1 = 28'h8000000;
            i_2 = 28'sd0;
            i_3 = 28'sd0;

            #1;


            check_outputs(28'h7FFFFFF, 28'h8000000, 28'h8000000, 28'h7FFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            i_0 = 28'sd1;
            i_1 = 28'sd1;
            i_2 = 28'sd-1;
            i_3 = 28'sd-1;

            #1;


            check_outputs(28'sd0, 28'sd0, 28'sd2, 28'sd2);
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
        input [27:0] expected_o_0;
        input [27:0] expected_o_1;
        input [27:0] expected_o_2;
        input [27:0] expected_o_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_0 === (expected_o_0 ^ o_0 ^ expected_o_0) &&
                expected_o_1 === (expected_o_1 ^ o_1 ^ expected_o_1) &&
                expected_o_2 === (expected_o_2 ^ o_2 ^ expected_o_2) &&
                expected_o_3 === (expected_o_3 ^ o_3 ^ expected_o_3)) begin
                $display("PASS");
                $display("  Outputs: o_0=%h, o_1=%h, o_2=%h, o_3=%h",
                         o_0, o_1, o_2, o_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_0=%h, o_1=%h, o_2=%h, o_3=%h",
                         expected_o_0, expected_o_1, expected_o_2, expected_o_3);
                $display("  Got:      o_0=%h, o_1=%h, o_2=%h, o_3=%h",
                         o_0, o_1, o_2, o_3);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] i_x;
    reg [10:0] i_y;
    wire [10:0] o_x1;
    wire [10:0] o_x2;
    wire [10:0] o_x3;
    wire [10:0] o_x4;
    wire [10:0] o_y1;
    wire [10:0] o_y2;
    wire [10:0] o_y3;
    wire [10:0] o_y4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_x(i_x),
        .i_y(i_y),
        .o_x1(o_x1),
        .o_x2(o_x2),
        .o_x3(o_x3),
        .o_x4(o_x4),
        .o_y1(o_y1),
        .o_y2(o_y2),
        .o_y3(o_y3),
        .o_y4(o_y4)
    );
    task run_test;

        input [10:0] tx;
        input [10:0] ty;
        begin
            i_x = tx;
            i_y = ty;
            #10;
            #1;

            check_outputs(
                tx - H_SIZE,  tx + H_SIZE,
                tx - H2_SIZE, tx + H2_SIZE,
                ty - V_SIZE,  ty + V_SIZE,
                ty - V2_SIZE, ty + V2_SIZE
            );
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Center Screen (512, 384)", test_num);
            run_test(11'd512, 11'd384);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Near Origin (60, 60)", test_num);
            run_test(11'd60, 11'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Large Coordinates (1500, 1500)", test_num);
            run_test(11'd1500, 11'd1500);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Asymmetric (800, 200)", test_num);
            run_test(11'd800, 11'd200);
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
        input [10:0] expected_o_x1;
        input [10:0] expected_o_x2;
        input [10:0] expected_o_x3;
        input [10:0] expected_o_x4;
        input [10:0] expected_o_y1;
        input [10:0] expected_o_y2;
        input [10:0] expected_o_y3;
        input [10:0] expected_o_y4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_x1 === (expected_o_x1 ^ o_x1 ^ expected_o_x1) &&
                expected_o_x2 === (expected_o_x2 ^ o_x2 ^ expected_o_x2) &&
                expected_o_x3 === (expected_o_x3 ^ o_x3 ^ expected_o_x3) &&
                expected_o_x4 === (expected_o_x4 ^ o_x4 ^ expected_o_x4) &&
                expected_o_y1 === (expected_o_y1 ^ o_y1 ^ expected_o_y1) &&
                expected_o_y2 === (expected_o_y2 ^ o_y2 ^ expected_o_y2) &&
                expected_o_y3 === (expected_o_y3 ^ o_y3 ^ expected_o_y3) &&
                expected_o_y4 === (expected_o_y4 ^ o_y4 ^ expected_o_y4)) begin
                $display("PASS");
                $display("  Outputs: o_x1=%h, o_x2=%h, o_x3=%h, o_x4=%h, o_y1=%h, o_y2=%h, o_y3=%h, o_y4=%h",
                         o_x1, o_x2, o_x3, o_x4, o_y1, o_y2, o_y3, o_y4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_x1=%h, o_x2=%h, o_x3=%h, o_x4=%h, o_y1=%h, o_y2=%h, o_y3=%h, o_y4=%h",
                         expected_o_x1, expected_o_x2, expected_o_x3, expected_o_x4, expected_o_y1, expected_o_y2, expected_o_y3, expected_o_y4);
                $display("  Got:      o_x1=%h, o_x2=%h, o_x3=%h, o_x4=%h, o_y1=%h, o_y2=%h, o_y3=%h, o_y4=%h",
                         o_x1, o_x2, o_x3, o_x4, o_y1, o_y2, o_y3, o_y4);
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

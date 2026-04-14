`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] i_double_fig;
    wire [3:0] o_left;
    wire [3:0] o_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_double_fig(i_double_fig),
        .o_left(o_left),
        .o_right(o_right)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Input = 0", test_num);
        i_double_fig = 7'd0;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Input = 7 (Single digit)", test_num);
        i_double_fig = 7'd7;
        #1;

        check_outputs(4'd0, 4'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Input = 10 (Edge of tens)", test_num);
        i_double_fig = 7'd10;
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Input = 25", test_num);
        i_double_fig = 7'd25;
        #1;

        check_outputs(4'd2, 4'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Input = 50 (Multiple of 10)", test_num);
        i_double_fig = 7'd50;
        #1;

        check_outputs(4'd5, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Input = 89", test_num);
        i_double_fig = 7'd89;
        #1;

        check_outputs(4'd8, 4'd9);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Input = 99 (Max 2-digit value)", test_num);
        i_double_fig = 7'd99;
        #1;

        check_outputs(4'd9, 4'd9);
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
        input [3:0] expected_o_left;
        input [3:0] expected_o_right;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_left === (expected_o_left ^ o_left ^ expected_o_left) &&
                expected_o_right === (expected_o_right ^ o_right ^ expected_o_right)) begin
                $display("PASS");
                $display("  Outputs: o_left=%h, o_right=%h",
                         o_left, o_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_left=%h, o_right=%h",
                         expected_o_left, expected_o_right);
                $display("  Got:      o_left=%h, o_right=%h",
                         o_left, o_right);
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

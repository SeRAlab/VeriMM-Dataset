`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg [1:0] select;
    wire [2:0] comparison_result;
    wire [1:0] input_selected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .select(select),
        .comparison_result(comparison_result),
        .input_selected(input_selected)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: a > b (a=5, b=2)", test_num);
        a = 3'd5;
        b = 3'd2;
        select = 2'b11;
        #1;

        check_outputs(3'd5, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: b > a (a=1, b=6)", test_num);
        a = 3'd1;
        b = 3'd6;
        select = 2'b00;
        #1;

        check_outputs(3'd6, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: a == b, select = 00", test_num);
        a = 3'd4;
        b = 3'd4;
        select = 2'b00;
        #1;

        check_outputs(3'd4, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: a == b, select = 01", test_num);
        a = 3'd3;
        b = 3'd3;
        select = 2'b01;
        #1;

        check_outputs(3'd3, 2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: a == b, select = 10", test_num);
        a = 3'd7;
        b = 3'd7;
        select = 2'b10;
        #1;

        check_outputs(3'd7, 2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: a == b, select = 11", test_num);
        a = 3'd0;
        b = 3'd0;
        select = 2'b11;
        #1;

        check_outputs(3'd0, 2'b11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: a=7, b=0", test_num);
        a = 3'd7;
        b = 3'd0;
        select = 2'b10;
        #1;

        check_outputs(3'd7, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: a=0, b=7", test_num);
        a = 3'd0;
        b = 3'd7;
        select = 2'b11;
        #1;

        check_outputs(3'd7, 2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: a=4, b=3", test_num);
        a = 3'd4;
        b = 3'd3;
        select = 2'b01;
        #1;

        check_outputs(3'd4, 2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: a=5, b=6", test_num);
        a = 3'd5;
        b = 3'd6;
        select = 2'b00;
        #1;

        check_outputs(3'd6, 2'b01);
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
        input [2:0] expected_comparison_result;
        input [1:0] expected_input_selected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comparison_result === (expected_comparison_result ^ comparison_result ^ expected_comparison_result) &&
                expected_input_selected === (expected_input_selected ^ input_selected ^ expected_input_selected)) begin
                $display("PASS");
                $display("  Outputs: comparison_result=%h, input_selected=%h",
                         comparison_result, input_selected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comparison_result=%h, input_selected=%h",
                         expected_comparison_result, expected_input_selected);
                $display("  Got:      comparison_result=%h, input_selected=%h",
                         comparison_result, input_selected);
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

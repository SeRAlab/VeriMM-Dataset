`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg clk;
    reg [1:0] select;
    wire Y0;
    wire Y1;
    wire Y2;
    wire Y3;
    wire [2:0] comparison_result;
    wire [1:0] final_output;
    wire [1:0] input_selected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .select(select),
        .Y0(Y0),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3),
        .comparison_result(comparison_result),
        .final_output(final_output),
        .input_selected(input_selected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 3'b000;
            b = 3'b000;
            select = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: a > b, select=01", test_num);
            a = 3'b101;
            b = 3'b010;
            select = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, 0, 0, 3'b001, 2'b01, 2'b01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: a < b, select=10", test_num);
            a = 3'b001;
            b = 3'b110;
            select = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 1, 0, 3'b010, 2'b10, 2'b10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: a == b, select=11", test_num);
            a = 3'b111;
            b = 3'b111;
            select = 2'b11;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 1, 3'b100, 2'b11, 2'b11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: select=00 (Result Zeroed)", test_num);
            a = 3'b111;
            b = 3'b000;
            select = 2'b00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0, 0, 3'b000, 2'b00, 2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: a=0, b=0, select=01", test_num);
            a = 3'b000;
            b = 3'b000;
            select = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 1, 3'b100, 2'b11, 2'b01);
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
        input expected_Y0;
        input expected_Y1;
        input expected_Y2;
        input expected_Y3;
        input [2:0] expected_comparison_result;
        input [1:0] expected_final_output;
        input [1:0] expected_input_selected;
        begin
            if (expected_Y0 === (expected_Y0 ^ Y0 ^ expected_Y0) &&
                expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3) &&
                expected_comparison_result === (expected_comparison_result ^ comparison_result ^ expected_comparison_result) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_input_selected === (expected_input_selected ^ input_selected ^ expected_input_selected)) begin
                $display("PASS");
                $display("  Outputs: Y0=%b, Y1=%b, Y2=%b, Y3=%b, comparison_result=%h, final_output=%h, input_selected=%h",
                         Y0, Y1, Y2, Y3, comparison_result, final_output, input_selected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y0=%b, Y1=%b, Y2=%b, Y3=%b, comparison_result=%h, final_output=%h, input_selected=%h",
                         expected_Y0, expected_Y1, expected_Y2, expected_Y3, expected_comparison_result, expected_final_output, expected_input_selected);
                $display("  Got:      Y0=%b, Y1=%b, Y2=%b, Y3=%b, comparison_result=%h, final_output=%h, input_selected=%h",
                         Y0, Y1, Y2, Y3, comparison_result, final_output, input_selected);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, clk, select, Y0, Y1, Y2, Y3, comparison_result, final_output, input_selected);
    end

endmodule

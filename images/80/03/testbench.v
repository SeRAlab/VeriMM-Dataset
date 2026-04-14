`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Data_X_i;
    reg [31:0] Data_Y_i;
    reg add_subt_i;
    reg clk;
    reg load_a_i;
    reg load_b_i;
    reg rst;
    wire [30:0] DMP_o;
    wire [30:0] DmP_o;
    wire real_op_o;
    wire sign_final_result_o;
    wire zero_flag_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_X_i(Data_X_i),
        .Data_Y_i(Data_Y_i),
        .add_subt_i(add_subt_i),
        .clk(clk),
        .load_a_i(load_a_i),
        .load_b_i(load_b_i),
        .rst(rst),
        .DMP_o(DMP_o),
        .DmP_o(DmP_o),
        .real_op_o(real_op_o),
        .sign_final_result_o(sign_final_result_o),
        .zero_flag_o(zero_flag_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        load_a_i = 0;
        load_b_i = 0;
        Data_X_i = 0;
        Data_Y_i = 0;
        add_subt_i = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        Data_X_i = 32'd10;
        load_a_i = 1;
        @(posedge clk);
        load_a_i = 0;
        Data_Y_i = 32'd20;
        load_b_i = 1;
        @(posedge clk);
        load_b_i = 0;
        add_subt_i = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(31'd30, 31'd30, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        Data_X_i = 32'd50;
        load_a_i = 1;
        @(posedge clk);
        load_a_i = 0;
        Data_Y_i = 32'd20;
        load_b_i = 1;
        @(posedge clk);
        load_b_i = 0;
        add_subt_i = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(31'd30, 31'd30, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        Data_X_i = 32'hABC;
        load_a_i = 1;
        @(posedge clk);
        load_a_i = 0;
        Data_Y_i = 32'hABC;
        load_b_i = 1;
        @(posedge clk);
        load_b_i = 0;
        add_subt_i = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(31'd0, 31'd0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        Data_X_i = 32'd20;
        load_a_i = 1;
        @(posedge clk);
        load_a_i = 0;
        Data_Y_i = 32'd50;
        load_b_i = 1;
        @(posedge clk);
        load_b_i = 0;
        add_subt_i = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(31'h7FFFFFE2, 31'h7FFFFFE2, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        Data_X_i = 32'd100;
        load_a_i = 1;
        @(posedge clk);
        load_a_i = 0;
        Data_Y_i = 32'hFFFFFFEC;
        load_b_i = 1;
        @(posedge clk);
        load_b_i = 0;
        add_subt_i = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(31'd80, 31'd80, 1'b0, 1'b0, 1'b0);
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
        input [30:0] expected_DMP_o;
        input [30:0] expected_DmP_o;
        input expected_real_op_o;
        input expected_sign_final_result_o;
        input expected_zero_flag_o;
        begin
            if (expected_DMP_o === (expected_DMP_o ^ DMP_o ^ expected_DMP_o) &&
                expected_DmP_o === (expected_DmP_o ^ DmP_o ^ expected_DmP_o) &&
                expected_real_op_o === (expected_real_op_o ^ real_op_o ^ expected_real_op_o) &&
                expected_sign_final_result_o === (expected_sign_final_result_o ^ sign_final_result_o ^ expected_sign_final_result_o) &&
                expected_zero_flag_o === (expected_zero_flag_o ^ zero_flag_o ^ expected_zero_flag_o)) begin
                $display("PASS");
                $display("  Outputs: DMP_o=%h, DmP_o=%h, real_op_o=%b, sign_final_result_o=%b, zero_flag_o=%b",
                         DMP_o, DmP_o, real_op_o, sign_final_result_o, zero_flag_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DMP_o=%h, DmP_o=%h, real_op_o=%b, sign_final_result_o=%b, zero_flag_o=%b",
                         expected_DMP_o, expected_DmP_o, expected_real_op_o, expected_sign_final_result_o, expected_zero_flag_o);
                $display("  Got:      DMP_o=%h, DmP_o=%h, real_op_o=%b, sign_final_result_o=%b, zero_flag_o=%b",
                         DMP_o, DmP_o, real_op_o, sign_final_result_o, zero_flag_o);
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
        $dumpvars(0,Data_X_i, Data_Y_i, add_subt_i, clk, load_a_i, load_b_i, rst, DMP_o, DmP_o, real_op_o, sign_final_result_o, zero_flag_o);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] alu_i;
    reg clk_i;
    reg control_load_i;
    reg control_store_i;
    reg control_take_branch_i;
    reg do_wb_i;
    reg rst_i;
    reg [4:0] wb_reg_i;
    wire do_wb_o;
    wire stall_o;
    wire [4:0] wb_reg_o;
    wire [31:0] wb_val_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_i(alu_i),
        .clk_i(clk_i),
        .control_load_i(control_load_i),
        .control_store_i(control_store_i),
        .control_take_branch_i(control_take_branch_i),
        .do_wb_i(do_wb_i),
        .rst_i(rst_i),
        .wb_reg_i(wb_reg_i),
        .do_wb_o(do_wb_o),
        .stall_o(stall_o),
        .wb_reg_o(wb_reg_o),
        .wb_val_o(wb_val_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            alu_i = 0;
            control_load_i = 0;
            control_store_i = 0;
            control_take_branch_i = 0;
            do_wb_i = 0;
            wb_reg_i = 0;
            @(posedge clk_i);
            #1 rst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Check...");
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: ALU Passthrough...");
            reset_dut();
            alu_i = 32'hA5A5_B6B6;
            do_wb_i = 1;
            wb_reg_i = 5'd12;
            control_load_i = 0;
            control_store_i = 0;

            @(posedge clk_i);
            #1;
            #1;

            check_outputs(1, 0, 5'd12, 32'hA5A5_B6B6);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Load Logic...");
            reset_dut();
            alu_i = 32'h1111_2222;
            control_load_i = 1;
            control_store_i = 0;
            do_wb_i = 1;
            wb_reg_i = 5'd5;

            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1, 0, 5'd5, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Store Logic...");
            reset_dut();
            alu_i = 32'hFFFF_0000;
            control_load_i = 0;
            control_store_i = 1;
            do_wb_i = 0;
            wb_reg_i = 5'd0;

            @(posedge clk_i);
            #1;
            #1;

            check_outputs(0, 0, 5'd0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Branch Handling...");
            reset_dut();
            alu_i = 32'h0000_00BC;
            control_take_branch_i = 1;
            do_wb_i = 0;

            @(posedge clk_i);
            #1;
            #1;

            check_outputs(0, 0, 0, 32'h0000_00BC);
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
        input expected_do_wb_o;
        input expected_stall_o;
        input [4:0] expected_wb_reg_o;
        input [31:0] expected_wb_val_o;
        begin
            if (expected_do_wb_o === (expected_do_wb_o ^ do_wb_o ^ expected_do_wb_o) &&
                expected_stall_o === (expected_stall_o ^ stall_o ^ expected_stall_o) &&
                expected_wb_reg_o === (expected_wb_reg_o ^ wb_reg_o ^ expected_wb_reg_o) &&
                expected_wb_val_o === (expected_wb_val_o ^ wb_val_o ^ expected_wb_val_o)) begin
                $display("PASS");
                $display("  Outputs: do_wb_o=%b, stall_o=%b, wb_reg_o=%h, wb_val_o=%h",
                         do_wb_o, stall_o, wb_reg_o, wb_val_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: do_wb_o=%b, stall_o=%b, wb_reg_o=%h, wb_val_o=%h",
                         expected_do_wb_o, expected_stall_o, expected_wb_reg_o, expected_wb_val_o);
                $display("  Got:      do_wb_o=%b, stall_o=%b, wb_reg_o=%h, wb_val_o=%h",
                         do_wb_o, stall_o, wb_reg_o, wb_val_o);
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
        $dumpvars(0,alu_i, clk_i, control_load_i, control_store_i, control_take_branch_i, do_wb_i, rst_i, wb_reg_i, do_wb_o, stall_o, wb_reg_o, wb_val_o);
    end

endmodule

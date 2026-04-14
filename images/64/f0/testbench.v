`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] alu_result_i;
    reg clk;
    reg [31:0] lsu_result_i;
    reg op_jal_i;
    reg op_lsu_load_i;
    reg op_mfspr_i;
    reg [31:0] pc_fetch_next_i;
    reg [31:0] ppc_i;
    reg rst;
    reg [31:0] spr_i;
    wire [31:0] rf_result_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_result_i(alu_result_i),
        .clk(clk),
        .lsu_result_i(lsu_result_i),
        .op_jal_i(op_jal_i),
        .op_lsu_load_i(op_lsu_load_i),
        .op_mfspr_i(op_mfspr_i),
        .pc_fetch_next_i(pc_fetch_next_i),
        .ppc_i(ppc_i),
        .rst(rst),
        .spr_i(spr_i),
        .rf_result_o(rf_result_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing Reset", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing ALU Result Selection (Default)", test_num);
        reset_dut();
        alu_result_i = 32'hA1A1_A1A1;
        op_jal_i = 0;
        op_lsu_load_i = 0;
        op_mfspr_i = 0;
        @(posedge clk);
        #1;

        check_outputs(32'hA1A1_A1A1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing JAL Selection (PC Fetch Next)", test_num);
        reset_dut();
        pc_fetch_next_i = 32'hC3C3_C3C3;
        op_jal_i = 1;
        op_lsu_load_i = 0;
        op_mfspr_i = 0;
        @(posedge clk);
        #1;

        check_outputs(32'hC3C3_C3C3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing LSU Selection", test_num);
        reset_dut();
        lsu_result_i = 32'hB2B2_B2B2;
        op_jal_i = 0;
        op_lsu_load_i = 1;
        op_mfspr_i = 0;
        @(posedge clk);
        #1;

        check_outputs(32'hB2B2_B2B2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing SPR Selection", test_num);
        reset_dut();
        spr_i = 32'hD4D4_D4D4;
        op_jal_i = 0;
        op_lsu_load_i = 0;
        op_mfspr_i = 1;
        @(posedge clk);
        #1;

        check_outputs(32'hD4D4_D4D4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing Priority (JAL > LSU)", test_num);
        reset_dut();
        pc_fetch_next_i = 32'hC3C3_C3C3;
        lsu_result_i = 32'hB2B2_B2B2;
        op_jal_i = 1;
        op_lsu_load_i = 1;
        op_mfspr_i = 0;
        @(posedge clk);
        #1;

        check_outputs(32'hC3C3_C3C3);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing Priority (LSU > SPR)", test_num);
        reset_dut();
        lsu_result_i = 32'hB2B2_B2B2;
        spr_i = 32'hD4D4_D4D4;
        op_jal_i = 0;
        op_lsu_load_i = 1;
        op_mfspr_i = 1;
        @(posedge clk);
        #1;

        check_outputs(32'hB2B2_B2B2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Testing Priority (SPR > ALU)", test_num);
        reset_dut();
        spr_i = 32'hD4D4_D4D4;
        alu_result_i = 32'hA1A1_A1A1;
        op_jal_i = 0;
        op_lsu_load_i = 0;
        op_mfspr_i = 1;
        @(posedge clk);
        #1;

        check_outputs(32'hD4D4_D4D4);
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
        input [31:0] expected_rf_result_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rf_result_o === (expected_rf_result_o ^ rf_result_o ^ expected_rf_result_o)) begin
                $display("PASS");
                $display("  Outputs: rf_result_o=%h",
                         rf_result_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rf_result_o=%h",
                         expected_rf_result_o);
                $display("  Got:      rf_result_o=%h",
                         rf_result_o);
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

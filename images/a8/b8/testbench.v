`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dir_clear_c4;
    reg [7:0] inval_mask_c4;
    reg [3:0] lkup_panel_en_c4;
    reg [1:0] lkup_row_en_c4;
    reg [15:0] lkup_wr_data_c4;
    reg rd_en_c4;
    reg [7:0] rw_entry_c4;
    reg [3:0] rw_panel_en_c4;
    reg [1:0] rw_row_en_c4;
    reg wr_en_c4;
    wire dir_clear_c4_buf;
    wire inval_mask_c4_buf;
    wire [7:0] lkup_en_c4_buf;
    wire [15:0] lkup_wr_data_c4_buf;
    wire [7:0] rd_en_c4_buf;
    wire [7:0] rw_dec_c4_buf;
    wire [7:0] rw_entry_c4_buf;
    wire [7:0] wr_en_c4_buf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dir_clear_c4(dir_clear_c4),
        .inval_mask_c4(inval_mask_c4),
        .lkup_panel_en_c4(lkup_panel_en_c4),
        .lkup_row_en_c4(lkup_row_en_c4),
        .lkup_wr_data_c4(lkup_wr_data_c4),
        .rd_en_c4(rd_en_c4),
        .rw_entry_c4(rw_entry_c4),
        .rw_panel_en_c4(rw_panel_en_c4),
        .rw_row_en_c4(rw_row_en_c4),
        .wr_en_c4(wr_en_c4),
        .dir_clear_c4_buf(dir_clear_c4_buf),
        .inval_mask_c4_buf(inval_mask_c4_buf),
        .lkup_en_c4_buf(lkup_en_c4_buf),
        .lkup_wr_data_c4_buf(lkup_wr_data_c4_buf),
        .rd_en_c4_buf(rd_en_c4_buf),
        .rw_dec_c4_buf(rw_dec_c4_buf),
        .rw_entry_c4_buf(rw_entry_c4_buf),
        .wr_en_c4_buf(wr_en_c4_buf)
    );
    task testcase001;

        begin
            test_num = 1;

            dir_clear_c4 = 0;
            inval_mask_c4 = 8'h00;
            lkup_panel_en_c4 = 4'b0000;
            lkup_row_en_c4 = 2'b00;
            lkup_wr_data_c4 = 16'h0000;
            rd_en_c4 = 0;
            rw_entry_c4 = 8'h00;
            rw_panel_en_c4 = 4'b0000;
            rw_row_en_c4 = 2'b00;
            wr_en_c4 = 0;


            #1;



            check_outputs(0, 0, 8'h00, 16'h0000, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            rd_en_c4 = 1;
            wr_en_c4 = 0;
            rw_row_en_c4 = 2'b01;
            rw_panel_en_c4 = 4'b0001;


            #1;



            check_outputs(0, 0, 8'h00, 16'h0000, 8'h01, 8'h01, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            rd_en_c4 = 0;
            wr_en_c4 = 1;
            rw_row_en_c4 = 2'b10;
            rw_panel_en_c4 = 4'b1000;


            #1;



            check_outputs(0, 0, 8'h00, 16'h0000, 8'h00, 8'h80, 8'h00, 8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            lkup_row_en_c4 = 2'b01;
            lkup_panel_en_c4 = 4'b0100;


            #1;



            check_outputs(0, 0, 8'h04, 16'h0000, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            lkup_row_en_c4 = 2'b10;
            lkup_panel_en_c4 = 4'b0010;


            #1;



            check_outputs(0, 0, 8'h20, 16'h0000, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            rw_entry_c4 = 8'hAA;
            lkup_wr_data_c4 = 16'hDEAD;

            #1;


            check_outputs(0, 0, 8'h20, 16'hDEAD, 8'h00, 8'h00, 8'hAA, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            dir_clear_c4 = 1;
            inval_mask_c4 = 8'hF0;

            #1;


            check_outputs(1, 1, 8'h20, 16'hDEAD, 8'h00, 8'h00, 8'hAA, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            rd_en_c4 = 1;
            wr_en_c4 = 0;
            rw_row_en_c4 = 2'b11;
            rw_panel_en_c4 = 4'b1111;

            #1;


            check_outputs(1, 1, 8'h20, 16'hDEAD, 8'hFF, 8'hFF, 8'hAA, 8'h00);
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
        input expected_dir_clear_c4_buf;
        input expected_inval_mask_c4_buf;
        input [7:0] expected_lkup_en_c4_buf;
        input [15:0] expected_lkup_wr_data_c4_buf;
        input [7:0] expected_rd_en_c4_buf;
        input [7:0] expected_rw_dec_c4_buf;
        input [7:0] expected_rw_entry_c4_buf;
        input [7:0] expected_wr_en_c4_buf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dir_clear_c4_buf === (expected_dir_clear_c4_buf ^ dir_clear_c4_buf ^ expected_dir_clear_c4_buf) &&
                expected_inval_mask_c4_buf === (expected_inval_mask_c4_buf ^ inval_mask_c4_buf ^ expected_inval_mask_c4_buf) &&
                expected_lkup_en_c4_buf === (expected_lkup_en_c4_buf ^ lkup_en_c4_buf ^ expected_lkup_en_c4_buf) &&
                expected_lkup_wr_data_c4_buf === (expected_lkup_wr_data_c4_buf ^ lkup_wr_data_c4_buf ^ expected_lkup_wr_data_c4_buf) &&
                expected_rd_en_c4_buf === (expected_rd_en_c4_buf ^ rd_en_c4_buf ^ expected_rd_en_c4_buf) &&
                expected_rw_dec_c4_buf === (expected_rw_dec_c4_buf ^ rw_dec_c4_buf ^ expected_rw_dec_c4_buf) &&
                expected_rw_entry_c4_buf === (expected_rw_entry_c4_buf ^ rw_entry_c4_buf ^ expected_rw_entry_c4_buf) &&
                expected_wr_en_c4_buf === (expected_wr_en_c4_buf ^ wr_en_c4_buf ^ expected_wr_en_c4_buf)) begin
                $display("PASS");
                $display("  Outputs: dir_clear_c4_buf=%b, inval_mask_c4_buf=%b, lkup_en_c4_buf=%h, lkup_wr_data_c4_buf=%h, rd_en_c4_buf=%h, rw_dec_c4_buf=%h, rw_entry_c4_buf=%h, wr_en_c4_buf=%h",
                         dir_clear_c4_buf, inval_mask_c4_buf, lkup_en_c4_buf, lkup_wr_data_c4_buf, rd_en_c4_buf, rw_dec_c4_buf, rw_entry_c4_buf, wr_en_c4_buf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dir_clear_c4_buf=%b, inval_mask_c4_buf=%b, lkup_en_c4_buf=%h, lkup_wr_data_c4_buf=%h, rd_en_c4_buf=%h, rw_dec_c4_buf=%h, rw_entry_c4_buf=%h, wr_en_c4_buf=%h",
                         expected_dir_clear_c4_buf, expected_inval_mask_c4_buf, expected_lkup_en_c4_buf, expected_lkup_wr_data_c4_buf, expected_rd_en_c4_buf, expected_rw_dec_c4_buf, expected_rw_entry_c4_buf, expected_wr_en_c4_buf);
                $display("  Got:      dir_clear_c4_buf=%b, inval_mask_c4_buf=%b, lkup_en_c4_buf=%h, lkup_wr_data_c4_buf=%h, rd_en_c4_buf=%h, rw_dec_c4_buf=%h, rw_entry_c4_buf=%h, wr_en_c4_buf=%h",
                         dir_clear_c4_buf, inval_mask_c4_buf, lkup_en_c4_buf, lkup_wr_data_c4_buf, rd_en_c4_buf, rw_dec_c4_buf, rw_entry_c4_buf, wr_en_c4_buf);
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

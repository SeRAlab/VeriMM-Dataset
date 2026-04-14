`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [155:0] scdata_sctag_decc_c6_ctr;
    reg [3:0] sctag_scdata_col_offset_c2;
    reg sctag_scdata_fb_hit_c3;
    reg sctag_scdata_fbrd_c3;
    reg sctag_scdata_rd_wr_c2;
    reg [9:0] sctag_scdata_set_c2;
    reg [77:0] sctag_scdata_stdecc_c2;
    reg [11:0] sctag_scdata_way_sel_c2;
    reg [15:0] sctag_scdata_word_en_c2;
    wire [155:0] scdata_sctag_decc_c6;
    wire [3:0] sctag_scdata_col_offset_c2_buf;
    wire sctag_scdata_fb_hit_c3_buf;
    wire sctag_scdata_fbrd_c3_buf;
    wire sctag_scdata_rd_wr_c2_buf;
    wire [9:0] sctag_scdata_set_c2_buf;
    wire [77:0] sctag_scdata_stdecc_c2_buf;
    wire [11:0] sctag_scdata_way_sel_c2_buf;
    wire [15:0] sctag_scdata_word_en_c2_buf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .scdata_sctag_decc_c6_ctr(scdata_sctag_decc_c6_ctr),
        .sctag_scdata_col_offset_c2(sctag_scdata_col_offset_c2),
        .sctag_scdata_fb_hit_c3(sctag_scdata_fb_hit_c3),
        .sctag_scdata_fbrd_c3(sctag_scdata_fbrd_c3),
        .sctag_scdata_rd_wr_c2(sctag_scdata_rd_wr_c2),
        .sctag_scdata_set_c2(sctag_scdata_set_c2),
        .sctag_scdata_stdecc_c2(sctag_scdata_stdecc_c2),
        .sctag_scdata_way_sel_c2(sctag_scdata_way_sel_c2),
        .sctag_scdata_word_en_c2(sctag_scdata_word_en_c2),
        .scdata_sctag_decc_c6(scdata_sctag_decc_c6),
        .sctag_scdata_col_offset_c2_buf(sctag_scdata_col_offset_c2_buf),
        .sctag_scdata_fb_hit_c3_buf(sctag_scdata_fb_hit_c3_buf),
        .sctag_scdata_fbrd_c3_buf(sctag_scdata_fbrd_c3_buf),
        .sctag_scdata_rd_wr_c2_buf(sctag_scdata_rd_wr_c2_buf),
        .sctag_scdata_set_c2_buf(sctag_scdata_set_c2_buf),
        .sctag_scdata_stdecc_c2_buf(sctag_scdata_stdecc_c2_buf),
        .sctag_scdata_way_sel_c2_buf(sctag_scdata_way_sel_c2_buf),
        .sctag_scdata_word_en_c2_buf(sctag_scdata_word_en_c2_buf)
    );
    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            scdata_sctag_decc_c6_ctr = 156'h0;
            sctag_scdata_col_offset_c2 = 4'h0;
            sctag_scdata_fb_hit_c3 = 1'b0;
            sctag_scdata_fbrd_c3 = 1'b0;
            sctag_scdata_rd_wr_c2 = 1'b0;
            sctag_scdata_set_c2 = 10'h0;
            sctag_scdata_stdecc_c2 = 78'h0;
            sctag_scdata_way_sel_c2 = 12'h0;
            sctag_scdata_word_en_c2 = 16'h0;

            #1;


            check_outputs(
                156'h0, 4'h0, 1'b0, 1'b0, 1'b0, 10'h0, 78'h0, 12'h0, 16'h0
            );
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All Ones");
            scdata_sctag_decc_c6_ctr = {156{1'b1}};
            sctag_scdata_col_offset_c2 = 4'hF;
            sctag_scdata_fb_hit_c3 = 1'b1;
            sctag_scdata_fbrd_c3 = 1'b1;
            sctag_scdata_rd_wr_c2 = 1'b1;
            sctag_scdata_set_c2 = 10'h3FF;
            sctag_scdata_stdecc_c2 = {78{1'b1}};
            sctag_scdata_way_sel_c2 = 12'hFFF;
            sctag_scdata_word_en_c2 = 16'hFFFF;

            #1;


            check_outputs(
                {156{1'b1}}, 4'hF, 1'b1, 1'b1, 1'b1, 10'h3FF, {78{1'b1}}, 12'hFFF, 16'hFFFF
            );
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Checkerboard Pattern A");
            scdata_sctag_decc_c6_ctr = 156'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            sctag_scdata_col_offset_c2 = 4'hA;
            sctag_scdata_fb_hit_c3 = 1'b1;
            sctag_scdata_fbrd_c3 = 1'b0;
            sctag_scdata_rd_wr_c2 = 1'b1;
            sctag_scdata_set_c2 = 10'h2AA;
            sctag_scdata_stdecc_c2 = 78'h2AAAAAAAAAAAAAAAAAAA;
            sctag_scdata_way_sel_c2 = 12'hAAA;
            sctag_scdata_word_en_c2 = 16'hAAAA;

            #1;


            check_outputs(
                156'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, 4'hA, 1'b1, 1'b0, 1'b1, 10'h2AA, 78'h2AAAAAAAAAAAAAAAAAAA, 12'hAAA, 16'hAAAA
            );
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Checkerboard Pattern 5");
            scdata_sctag_decc_c6_ctr = 156'h555555555555555555555555555555555555555;
            sctag_scdata_col_offset_c2 = 4'h5;
            sctag_scdata_fb_hit_c3 = 1'b0;
            sctag_scdata_fbrd_c3 = 1'b1;
            sctag_scdata_rd_wr_c2 = 1'b0;
            sctag_scdata_set_c2 = 10'h155;
            sctag_scdata_stdecc_c2 = 78'h1555555555555555555;
            sctag_scdata_way_sel_c2 = 12'h555;
            sctag_scdata_word_en_c2 = 16'h5555;

            #1;


            check_outputs(
                156'h555555555555555555555555555555555555555, 4'h5, 1'b0, 1'b1, 1'b0, 10'h155, 78'h1555555555555555555, 12'h555, 16'h5555
            );
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Random Walk/Specific Mix");
            scdata_sctag_decc_c6_ctr = 156'hDEADC0DEBEEFCAFEDEADC0DEBEEFCAFEDEADC0DE;
            sctag_scdata_col_offset_c2 = 4'h9;
            sctag_scdata_fb_hit_c3 = 1'b1;
            sctag_scdata_fbrd_c3 = 1'b1;
            sctag_scdata_rd_wr_c2 = 1'b0;
            sctag_scdata_set_c2 = 10'h123;
            sctag_scdata_stdecc_c2 = 78'h30123456789ABCDEF01;
            sctag_scdata_way_sel_c2 = 12'hC0D;
            sctag_scdata_word_en_c2 = 16'h8001;

            #1;


            check_outputs(
                156'hDEADC0DEBEEFCAFEDEADC0DEBEEFCAFEDEADC0DE, 4'h9, 1'b1, 1'b1, 1'b0, 10'h123, 78'h30123456789ABCDEF01, 12'hC0D, 16'h8001
            );
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
        input [155:0] expected_scdata_sctag_decc_c6;
        input [3:0] expected_sctag_scdata_col_offset_c2_buf;
        input expected_sctag_scdata_fb_hit_c3_buf;
        input expected_sctag_scdata_fbrd_c3_buf;
        input expected_sctag_scdata_rd_wr_c2_buf;
        input [9:0] expected_sctag_scdata_set_c2_buf;
        input [77:0] expected_sctag_scdata_stdecc_c2_buf;
        input [11:0] expected_sctag_scdata_way_sel_c2_buf;
        input [15:0] expected_sctag_scdata_word_en_c2_buf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_scdata_sctag_decc_c6 === (expected_scdata_sctag_decc_c6 ^ scdata_sctag_decc_c6 ^ expected_scdata_sctag_decc_c6) &&
                expected_sctag_scdata_col_offset_c2_buf === (expected_sctag_scdata_col_offset_c2_buf ^ sctag_scdata_col_offset_c2_buf ^ expected_sctag_scdata_col_offset_c2_buf) &&
                expected_sctag_scdata_fb_hit_c3_buf === (expected_sctag_scdata_fb_hit_c3_buf ^ sctag_scdata_fb_hit_c3_buf ^ expected_sctag_scdata_fb_hit_c3_buf) &&
                expected_sctag_scdata_fbrd_c3_buf === (expected_sctag_scdata_fbrd_c3_buf ^ sctag_scdata_fbrd_c3_buf ^ expected_sctag_scdata_fbrd_c3_buf) &&
                expected_sctag_scdata_rd_wr_c2_buf === (expected_sctag_scdata_rd_wr_c2_buf ^ sctag_scdata_rd_wr_c2_buf ^ expected_sctag_scdata_rd_wr_c2_buf) &&
                expected_sctag_scdata_set_c2_buf === (expected_sctag_scdata_set_c2_buf ^ sctag_scdata_set_c2_buf ^ expected_sctag_scdata_set_c2_buf) &&
                expected_sctag_scdata_stdecc_c2_buf === (expected_sctag_scdata_stdecc_c2_buf ^ sctag_scdata_stdecc_c2_buf ^ expected_sctag_scdata_stdecc_c2_buf) &&
                expected_sctag_scdata_way_sel_c2_buf === (expected_sctag_scdata_way_sel_c2_buf ^ sctag_scdata_way_sel_c2_buf ^ expected_sctag_scdata_way_sel_c2_buf) &&
                expected_sctag_scdata_word_en_c2_buf === (expected_sctag_scdata_word_en_c2_buf ^ sctag_scdata_word_en_c2_buf ^ expected_sctag_scdata_word_en_c2_buf)) begin
                $display("PASS");
                $display("  Outputs: scdata_sctag_decc_c6=%h, sctag_scdata_col_offset_c2_buf=%h, sctag_scdata_fb_hit_c3_buf=%b, sctag_scdata_fbrd_c3_buf=%b, sctag_scdata_rd_wr_c2_buf=%b, sctag_scdata_set_c2_buf=%h, sctag_scdata_stdecc_c2_buf=%h, sctag_scdata_way_sel_c2_buf=%h, sctag_scdata_word_en_c2_buf=%h",
                         scdata_sctag_decc_c6, sctag_scdata_col_offset_c2_buf, sctag_scdata_fb_hit_c3_buf, sctag_scdata_fbrd_c3_buf, sctag_scdata_rd_wr_c2_buf, sctag_scdata_set_c2_buf, sctag_scdata_stdecc_c2_buf, sctag_scdata_way_sel_c2_buf, sctag_scdata_word_en_c2_buf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scdata_sctag_decc_c6=%h, sctag_scdata_col_offset_c2_buf=%h, sctag_scdata_fb_hit_c3_buf=%b, sctag_scdata_fbrd_c3_buf=%b, sctag_scdata_rd_wr_c2_buf=%b, sctag_scdata_set_c2_buf=%h, sctag_scdata_stdecc_c2_buf=%h, sctag_scdata_way_sel_c2_buf=%h, sctag_scdata_word_en_c2_buf=%h",
                         expected_scdata_sctag_decc_c6, expected_sctag_scdata_col_offset_c2_buf, expected_sctag_scdata_fb_hit_c3_buf, expected_sctag_scdata_fbrd_c3_buf, expected_sctag_scdata_rd_wr_c2_buf, expected_sctag_scdata_set_c2_buf, expected_sctag_scdata_stdecc_c2_buf, expected_sctag_scdata_way_sel_c2_buf, expected_sctag_scdata_word_en_c2_buf);
                $display("  Got:      scdata_sctag_decc_c6=%h, sctag_scdata_col_offset_c2_buf=%h, sctag_scdata_fb_hit_c3_buf=%b, sctag_scdata_fbrd_c3_buf=%b, sctag_scdata_rd_wr_c2_buf=%b, sctag_scdata_set_c2_buf=%h, sctag_scdata_stdecc_c2_buf=%h, sctag_scdata_way_sel_c2_buf=%h, sctag_scdata_word_en_c2_buf=%h",
                         scdata_sctag_decc_c6, sctag_scdata_col_offset_c2_buf, sctag_scdata_fb_hit_c3_buf, sctag_scdata_fbrd_c3_buf, sctag_scdata_rd_wr_c2_buf, sctag_scdata_set_c2_buf, sctag_scdata_stdecc_c2_buf, sctag_scdata_way_sel_c2_buf, sctag_scdata_word_en_c2_buf);
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

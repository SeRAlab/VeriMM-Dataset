`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] scdata_col_offset_c2;
    reg scdata_fb_hit_c3;
    reg scdata_fbrd_c3;
    reg scdata_rd_wr_c2;
    reg [9:0] scdata_set_c2;
    reg [11:0] scdata_way_sel_c2;
    reg [15:0] scdata_word_en_c2;
    wire [3:0] sctag_scdata_col_offset_c2;
    wire sctag_scdata_fb_hit_c3;
    wire sctag_scdata_fbrd_c3;
    wire sctag_scdata_rd_wr_c2;
    wire [9:0] sctag_scdata_set_c2;
    wire [11:0] sctag_scdata_way_sel_c2;
    wire [15:0] sctag_scdata_word_en_c2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .scdata_col_offset_c2(scdata_col_offset_c2),
        .scdata_fb_hit_c3(scdata_fb_hit_c3),
        .scdata_fbrd_c3(scdata_fbrd_c3),
        .scdata_rd_wr_c2(scdata_rd_wr_c2),
        .scdata_set_c2(scdata_set_c2),
        .scdata_way_sel_c2(scdata_way_sel_c2),
        .scdata_word_en_c2(scdata_word_en_c2),
        .sctag_scdata_col_offset_c2(sctag_scdata_col_offset_c2),
        .sctag_scdata_fb_hit_c3(sctag_scdata_fb_hit_c3),
        .sctag_scdata_fbrd_c3(sctag_scdata_fbrd_c3),
        .sctag_scdata_rd_wr_c2(sctag_scdata_rd_wr_c2),
        .sctag_scdata_set_c2(sctag_scdata_set_c2),
        .sctag_scdata_way_sel_c2(sctag_scdata_way_sel_c2),
        .sctag_scdata_word_en_c2(sctag_scdata_word_en_c2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All Zeros (Pass-through Check)", test_num);
            scdata_col_offset_c2 = 4'h0;
            scdata_fb_hit_c3 = 1'b0;
            scdata_fbrd_c3 = 1'b0;
            scdata_rd_wr_c2 = 1'b0;
            scdata_set_c2 = 10'h000;
            scdata_way_sel_c2 = 12'h000;
            scdata_word_en_c2 = 16'h0000;


            #1;



            check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 10'h000, 12'h000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: All Ones (Pass-through Check)", test_num);
            scdata_col_offset_c2 = 4'hF;
            scdata_fb_hit_c3 = 1'b1;
            scdata_fbrd_c3 = 1'b1;
            scdata_rd_wr_c2 = 1'b1;
            scdata_set_c2 = 10'h3FF;
            scdata_way_sel_c2 = 12'hFFF;
            scdata_word_en_c2 = 16'hFFFF;

            #1;


            check_outputs(4'hF, 1'b1, 1'b1, 1'b1, 10'h3FF, 12'hFFF, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Alternating Bit Pattern A", test_num);
            scdata_col_offset_c2 = 4'hA;
            scdata_fb_hit_c3 = 1'b1;
            scdata_fbrd_c3 = 1'b0;
            scdata_rd_wr_c2 = 1'b1;
            scdata_set_c2 = 10'h2AA;
            scdata_way_sel_c2 = 12'hAAA;
            scdata_word_en_c2 = 16'hAAAA;

            #1;


            check_outputs(4'hA, 1'b1, 1'b0, 1'b1, 10'h2AA, 12'hAAA, 16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Alternating Bit Pattern B", test_num);
            scdata_col_offset_c2 = 4'h5;
            scdata_fb_hit_c3 = 1'b0;
            scdata_fbrd_c3 = 1'b1;
            scdata_rd_wr_c2 = 1'b0;
            scdata_set_c2 = 10'h155;
            scdata_way_sel_c2 = 12'h555;
            scdata_word_en_c2 = 16'h5555;

            #1;


            check_outputs(4'h5, 1'b0, 1'b1, 1'b0, 10'h155, 12'h555, 16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Specific Cache Operation Scenario", test_num);

            scdata_col_offset_c2 = 4'h4;
            scdata_fb_hit_c3 = 1'b1;
            scdata_fbrd_c3 = 1'b1;
            scdata_rd_wr_c2 = 1'b1;
            scdata_set_c2 = 10'h123;
            scdata_way_sel_c2 = 12'h800;
            scdata_word_en_c2 = 16'h00FF;

            #1;


            check_outputs(4'h4, 1'b1, 1'b1, 1'b1, 10'h123, 12'h800, 16'h00FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Walking Bit Test", test_num);
            scdata_col_offset_c2 = 4'h8;
            scdata_fb_hit_c3 = 1'b0;
            scdata_fbrd_c3 = 1'b0;
            scdata_rd_wr_c2 = 1'b1;
            scdata_set_c2 = 10'h200;
            scdata_way_sel_c2 = 12'h400;
            scdata_word_en_c2 = 16'h8000;

            #1;


            check_outputs(4'h8, 1'b0, 1'b0, 1'b1, 10'h200, 12'h400, 16'h8000);
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
        input [3:0] expected_sctag_scdata_col_offset_c2;
        input expected_sctag_scdata_fb_hit_c3;
        input expected_sctag_scdata_fbrd_c3;
        input expected_sctag_scdata_rd_wr_c2;
        input [9:0] expected_sctag_scdata_set_c2;
        input [11:0] expected_sctag_scdata_way_sel_c2;
        input [15:0] expected_sctag_scdata_word_en_c2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sctag_scdata_col_offset_c2 === (expected_sctag_scdata_col_offset_c2 ^ sctag_scdata_col_offset_c2 ^ expected_sctag_scdata_col_offset_c2) &&
                expected_sctag_scdata_fb_hit_c3 === (expected_sctag_scdata_fb_hit_c3 ^ sctag_scdata_fb_hit_c3 ^ expected_sctag_scdata_fb_hit_c3) &&
                expected_sctag_scdata_fbrd_c3 === (expected_sctag_scdata_fbrd_c3 ^ sctag_scdata_fbrd_c3 ^ expected_sctag_scdata_fbrd_c3) &&
                expected_sctag_scdata_rd_wr_c2 === (expected_sctag_scdata_rd_wr_c2 ^ sctag_scdata_rd_wr_c2 ^ expected_sctag_scdata_rd_wr_c2) &&
                expected_sctag_scdata_set_c2 === (expected_sctag_scdata_set_c2 ^ sctag_scdata_set_c2 ^ expected_sctag_scdata_set_c2) &&
                expected_sctag_scdata_way_sel_c2 === (expected_sctag_scdata_way_sel_c2 ^ sctag_scdata_way_sel_c2 ^ expected_sctag_scdata_way_sel_c2) &&
                expected_sctag_scdata_word_en_c2 === (expected_sctag_scdata_word_en_c2 ^ sctag_scdata_word_en_c2 ^ expected_sctag_scdata_word_en_c2)) begin
                $display("PASS");
                $display("  Outputs: sctag_scdata_col_offset_c2=%h, sctag_scdata_fb_hit_c3=%b, sctag_scdata_fbrd_c3=%b, sctag_scdata_rd_wr_c2=%b, sctag_scdata_set_c2=%h, sctag_scdata_way_sel_c2=%h, sctag_scdata_word_en_c2=%h",
                         sctag_scdata_col_offset_c2, sctag_scdata_fb_hit_c3, sctag_scdata_fbrd_c3, sctag_scdata_rd_wr_c2, sctag_scdata_set_c2, sctag_scdata_way_sel_c2, sctag_scdata_word_en_c2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sctag_scdata_col_offset_c2=%h, sctag_scdata_fb_hit_c3=%b, sctag_scdata_fbrd_c3=%b, sctag_scdata_rd_wr_c2=%b, sctag_scdata_set_c2=%h, sctag_scdata_way_sel_c2=%h, sctag_scdata_word_en_c2=%h",
                         expected_sctag_scdata_col_offset_c2, expected_sctag_scdata_fb_hit_c3, expected_sctag_scdata_fbrd_c3, expected_sctag_scdata_rd_wr_c2, expected_sctag_scdata_set_c2, expected_sctag_scdata_way_sel_c2, expected_sctag_scdata_word_en_c2);
                $display("  Got:      sctag_scdata_col_offset_c2=%h, sctag_scdata_fb_hit_c3=%b, sctag_scdata_fbrd_c3=%b, sctag_scdata_rd_wr_c2=%b, sctag_scdata_set_c2=%h, sctag_scdata_way_sel_c2=%h, sctag_scdata_word_en_c2=%h",
                         sctag_scdata_col_offset_c2, sctag_scdata_fb_hit_c3, sctag_scdata_fbrd_c3, sctag_scdata_rd_wr_c2, sctag_scdata_set_c2, sctag_scdata_way_sel_c2, sctag_scdata_word_en_c2);
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

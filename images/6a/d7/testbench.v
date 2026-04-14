`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dir_vld_c4_l;
    reg dirrep_dir_wr_par_c4;
    reg lkup_addr8_c4;
    reg [29:0] tagdp_lkup_addr_c4;
    wire [32:0] lkup_wr_data_dn_buf;
    wire [32:0] lkup_wr_data_up_buf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dir_vld_c4_l(dir_vld_c4_l),
        .dirrep_dir_wr_par_c4(dirrep_dir_wr_par_c4),
        .lkup_addr8_c4(lkup_addr8_c4),
        .tagdp_lkup_addr_c4(tagdp_lkup_addr_c4),
        .lkup_wr_data_dn_buf(lkup_wr_data_dn_buf),
        .lkup_wr_data_up_buf(lkup_wr_data_up_buf)
    );
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            test_num = 1;
            dir_vld_c4_l = 1'b0;
            dirrep_dir_wr_par_c4 = 1'b0;
            lkup_addr8_c4 = 1'b0;
            tagdp_lkup_addr_c4 = 30'h0000_0000;

            #1;


            check_outputs(33'h0_0000_0000, 33'h0_0000_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones");
            test_num = 2;
            dir_vld_c4_l = 1'b1;
            dirrep_dir_wr_par_c4 = 1'b1;
            lkup_addr8_c4 = 1'b1;
            tagdp_lkup_addr_c4 = 30'h3FFF_FFFF;

            #1;


            check_outputs(33'h1_FFFF_FFFF, 33'h1_FFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Valid Active (MSB)");
            test_num = 3;
            dir_vld_c4_l = 1'b1;
            dirrep_dir_wr_par_c4 = 1'b0;
            lkup_addr8_c4 = 1'b0;
            tagdp_lkup_addr_c4 = 30'h0000_0000;

            #1;


            check_outputs(33'h1_0000_0000, 33'h1_0000_0000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Parity Bit Set");
            test_num = 4;
            dir_vld_c4_l = 1'b0;
            dirrep_dir_wr_par_c4 = 1'b1;
            lkup_addr8_c4 = 1'b0;
            tagdp_lkup_addr_c4 = 30'h0000_0000;

            #1;


            check_outputs(33'h0_8000_0000, 33'h0_8000_0000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Addr8 Bit Set");
            test_num = 5;
            dir_vld_c4_l = 1'b0;
            dirrep_dir_wr_par_c4 = 1'b0;
            lkup_addr8_c4 = 1'b1;
            tagdp_lkup_addr_c4 = 30'h0000_0000;

            #1;


            check_outputs(33'h0_4000_0000, 33'h0_4000_0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating Address Pattern");
            test_num = 6;
            dir_vld_c4_l = 1'b1;
            dirrep_dir_wr_par_c4 = 1'b0;
            lkup_addr8_c4 = 1'b1;
            tagdp_lkup_addr_c4 = 30'h2AAA_AAAA;



            #1;




            check_outputs(33'h1_5555_5555, 33'h1_5555_5555);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Random Data Pattern");
            test_num = 7;
            dir_vld_c4_l = 1'b0;
            dirrep_dir_wr_par_c4 = 1'b1;
            lkup_addr8_c4 = 1'b0;
            tagdp_lkup_addr_c4 = 30'h1234_5678;


            #1;



            check_outputs(33'h0_9234_5678, 33'h0_9234_5678);
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
        input [32:0] expected_lkup_wr_data_dn_buf;
        input [32:0] expected_lkup_wr_data_up_buf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lkup_wr_data_dn_buf === (expected_lkup_wr_data_dn_buf ^ lkup_wr_data_dn_buf ^ expected_lkup_wr_data_dn_buf) &&
                expected_lkup_wr_data_up_buf === (expected_lkup_wr_data_up_buf ^ lkup_wr_data_up_buf ^ expected_lkup_wr_data_up_buf)) begin
                $display("PASS");
                $display("  Outputs: lkup_wr_data_dn_buf=%h, lkup_wr_data_up_buf=%h",
                         lkup_wr_data_dn_buf, lkup_wr_data_up_buf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lkup_wr_data_dn_buf=%h, lkup_wr_data_up_buf=%h",
                         expected_lkup_wr_data_dn_buf, expected_lkup_wr_data_up_buf);
                $display("  Got:      lkup_wr_data_dn_buf=%h, lkup_wr_data_up_buf=%h",
                         lkup_wr_data_dn_buf, lkup_wr_data_up_buf);
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

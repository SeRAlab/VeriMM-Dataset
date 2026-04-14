`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PERun_wen;
    reg PERun_wten;
    reg accum_in_PopNB_mioi_oswt;
    reg accum_in_PopNB_mioi_oswt_pff;
    wire accum_in_PopNB_mioi_bdwt;
    wire accum_in_PopNB_mioi_biwt;
    wire accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PERun_wen(PERun_wen),
        .PERun_wten(PERun_wten),
        .accum_in_PopNB_mioi_oswt(accum_in_PopNB_mioi_oswt),
        .accum_in_PopNB_mioi_oswt_pff(accum_in_PopNB_mioi_oswt_pff),
        .accum_in_PopNB_mioi_bdwt(accum_in_PopNB_mioi_bdwt),
        .accum_in_PopNB_mioi_biwt(accum_in_PopNB_mioi_biwt),
        .accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct(accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct)
    );
    task testcase001;

        begin
            test_num = 1;
            PERun_wen = 1'b0;
            PERun_wten = 1'b0;
            accum_in_PopNB_mioi_oswt = 1'b0;
            accum_in_PopNB_mioi_oswt_pff = 1'b0;
            $display("Testcase %03d: Idle state (all inputs 0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            PERun_wen = 1'b0;
            PERun_wten = 1'b1;
            accum_in_PopNB_mioi_oswt = 1'b0;
            accum_in_PopNB_mioi_oswt_pff = 1'b0;
            $display("Testcase %03d: Testing bd-weight (PERun_wten=1)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            PERun_wen = 1'b0;
            PERun_wten = 1'b0;
            accum_in_PopNB_mioi_oswt = 1'b1;
            accum_in_PopNB_mioi_oswt_pff = 1'b0;
            $display("Testcase %03d: Testing bi-weight (PERun_wten=0, oswt=1)", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            PERun_wen = 1'b0;
            PERun_wten = 1'b1;
            accum_in_PopNB_mioi_oswt = 1'b1;
            accum_in_PopNB_mioi_oswt_pff = 1'b0;
            $display("Testcase %03d: Testing bi-weight suppression (PERun_wten=1, oswt=1)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            PERun_wen = 1'b1;
            PERun_wten = 1'b0;
            accum_in_PopNB_mioi_oswt = 1'b0;
            accum_in_PopNB_mioi_oswt_pff = 1'b1;
            $display("Testcase %03d: Testing ccore_start (PERun_wen=1, oswt_pff=1)", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            PERun_wen = 1'b0;
            PERun_wten = 1'b0;
            accum_in_PopNB_mioi_oswt = 1'b0;
            accum_in_PopNB_mioi_oswt_pff = 1'b1;
            $display("Testcase %03d: Testing ccore_start suppression (PERun_wen=0, oswt_pff=1)", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            PERun_wen = 1'b1;
            PERun_wten = 1'b1;
            accum_in_PopNB_mioi_oswt = 1'b0;
            accum_in_PopNB_mioi_oswt_pff = 1'b1;
            $display("Testcase %03d: Testing multiple active (bdwt and sct)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            PERun_wen = 1'b1;
            PERun_wten = 1'b1;
            accum_in_PopNB_mioi_oswt = 1'b1;
            accum_in_PopNB_mioi_oswt_pff = 1'b1;
            $display("Testcase %03d: Testing all inputs high", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
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
        input expected_accum_in_PopNB_mioi_bdwt;
        input expected_accum_in_PopNB_mioi_biwt;
        input expected_accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_accum_in_PopNB_mioi_bdwt === (expected_accum_in_PopNB_mioi_bdwt ^ accum_in_PopNB_mioi_bdwt ^ expected_accum_in_PopNB_mioi_bdwt) &&
                expected_accum_in_PopNB_mioi_biwt === (expected_accum_in_PopNB_mioi_biwt ^ accum_in_PopNB_mioi_biwt ^ expected_accum_in_PopNB_mioi_biwt) &&
                expected_accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct === (expected_accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct ^ accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct ^ expected_accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct)) begin
                $display("PASS");
                $display("  Outputs: accum_in_PopNB_mioi_bdwt=%b, accum_in_PopNB_mioi_biwt=%b, accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         accum_in_PopNB_mioi_bdwt, accum_in_PopNB_mioi_biwt, accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accum_in_PopNB_mioi_bdwt=%b, accum_in_PopNB_mioi_biwt=%b, accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         expected_accum_in_PopNB_mioi_bdwt, expected_accum_in_PopNB_mioi_biwt, expected_accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
                $display("  Got:      accum_in_PopNB_mioi_bdwt=%b, accum_in_PopNB_mioi_biwt=%b, accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         accum_in_PopNB_mioi_bdwt, accum_in_PopNB_mioi_biwt, accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
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

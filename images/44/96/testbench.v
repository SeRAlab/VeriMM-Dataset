`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PERun_wen;
    reg accum_out_Push_mioi_bcwt;
    reg accum_out_Push_mioi_ccs_ccore_done_sync_vld;
    reg accum_out_Push_mioi_oswt;
    reg accum_out_Push_mioi_oswt_pff;
    wire accum_out_Push_mioi_bdwt;
    wire accum_out_Push_mioi_biwt;
    wire accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PERun_wen(PERun_wen),
        .accum_out_Push_mioi_bcwt(accum_out_Push_mioi_bcwt),
        .accum_out_Push_mioi_ccs_ccore_done_sync_vld(accum_out_Push_mioi_ccs_ccore_done_sync_vld),
        .accum_out_Push_mioi_oswt(accum_out_Push_mioi_oswt),
        .accum_out_Push_mioi_oswt_pff(accum_out_Push_mioi_oswt_pff),
        .accum_out_Push_mioi_bdwt(accum_out_Push_mioi_bdwt),
        .accum_out_Push_mioi_biwt(accum_out_Push_mioi_biwt),
        .accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct(accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs low", test_num);
            PERun_wen = 0;
            accum_out_Push_mioi_oswt = 0;
            accum_out_Push_mioi_bcwt = 0;
            accum_out_Push_mioi_ccs_ccore_done_sync_vld = 0;
            accum_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify start trigger (sct) with PERun_wen and oswt_pff", test_num);
            PERun_wen = 1;
            accum_out_Push_mioi_oswt = 0;
            accum_out_Push_mioi_bcwt = 0;
            accum_out_Push_mioi_ccs_ccore_done_sync_vld = 0;
            accum_out_Push_mioi_oswt_pff = 1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sct should remain low if oswt_pff is low", test_num);
            PERun_wen = 1;
            accum_out_Push_mioi_oswt = 0;
            accum_out_Push_mioi_bcwt = 0;
            accum_out_Push_mioi_ccs_ccore_done_sync_vld = 0;
            accum_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify bdwt activation with oswt and sync_vld", test_num);
            PERun_wen = 0;
            accum_out_Push_mioi_oswt = 1;
            accum_out_Push_mioi_bcwt = 0;
            accum_out_Push_mioi_ccs_ccore_done_sync_vld = 1;
            accum_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify biwt activation with bcwt and sync_vld", test_num);
            PERun_wen = 0;
            accum_out_Push_mioi_oswt = 0;
            accum_out_Push_mioi_bcwt = 1;
            accum_out_Push_mioi_ccs_ccore_done_sync_vld = 1;
            accum_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify bdwt/biwt remain low if sync_vld is low", test_num);
            PERun_wen = 0;
            accum_out_Push_mioi_oswt = 1;
            accum_out_Push_mioi_bcwt = 1;
            accum_out_Push_mioi_ccs_ccore_done_sync_vld = 0;
            accum_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All outputs active", test_num);
            PERun_wen = 1;
            accum_out_Push_mioi_oswt = 1;
            accum_out_Push_mioi_bcwt = 1;
            accum_out_Push_mioi_ccs_ccore_done_sync_vld = 1;
            accum_out_Push_mioi_oswt_pff = 1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed signals verification", test_num);
            PERun_wen = 1;
            accum_out_Push_mioi_oswt = 1;
            accum_out_Push_mioi_bcwt = 0;
            accum_out_Push_mioi_ccs_ccore_done_sync_vld = 1;
            accum_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_accum_out_Push_mioi_bdwt;
        input expected_accum_out_Push_mioi_biwt;
        input expected_accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_accum_out_Push_mioi_bdwt === (expected_accum_out_Push_mioi_bdwt ^ accum_out_Push_mioi_bdwt ^ expected_accum_out_Push_mioi_bdwt) &&
                expected_accum_out_Push_mioi_biwt === (expected_accum_out_Push_mioi_biwt ^ accum_out_Push_mioi_biwt ^ expected_accum_out_Push_mioi_biwt) &&
                expected_accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct === (expected_accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct ^ accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct ^ expected_accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct)) begin
                $display("PASS");
                $display("  Outputs: accum_out_Push_mioi_bdwt=%b, accum_out_Push_mioi_biwt=%b, accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         accum_out_Push_mioi_bdwt, accum_out_Push_mioi_biwt, accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accum_out_Push_mioi_bdwt=%b, accum_out_Push_mioi_biwt=%b, accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         expected_accum_out_Push_mioi_bdwt, expected_accum_out_Push_mioi_biwt, expected_accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
                $display("  Got:      accum_out_Push_mioi_bdwt=%b, accum_out_Push_mioi_biwt=%b, accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         accum_out_Push_mioi_bdwt, accum_out_Push_mioi_biwt, accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
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

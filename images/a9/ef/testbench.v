`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PERun_wen;
    reg weight_out_Push_mioi_bcwt;
    reg weight_out_Push_mioi_ccs_ccore_done_sync_vld;
    reg weight_out_Push_mioi_oswt;
    reg weight_out_Push_mioi_oswt_pff;
    wire weight_out_Push_mioi_bdwt;
    wire weight_out_Push_mioi_biwt;
    wire weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PERun_wen(PERun_wen),
        .weight_out_Push_mioi_bcwt(weight_out_Push_mioi_bcwt),
        .weight_out_Push_mioi_ccs_ccore_done_sync_vld(weight_out_Push_mioi_ccs_ccore_done_sync_vld),
        .weight_out_Push_mioi_oswt(weight_out_Push_mioi_oswt),
        .weight_out_Push_mioi_oswt_pff(weight_out_Push_mioi_oswt_pff),
        .weight_out_Push_mioi_bdwt(weight_out_Push_mioi_bdwt),
        .weight_out_Push_mioi_biwt(weight_out_Push_mioi_biwt),
        .weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct(weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct)
    );
    task testcase001;

        begin
            $display("Testcase 001: All inputs zero");
            test_num = test_num + 1;
            PERun_wen = 0;
            weight_out_Push_mioi_bcwt = 0;
            weight_out_Push_mioi_ccs_ccore_done_sync_vld = 0;
            weight_out_Push_mioi_oswt = 0;
            weight_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Test weight_out_Push_mioi_bdwt activation");
            test_num = test_num + 1;
            PERun_wen = 1;
            weight_out_Push_mioi_bcwt = 0;
            weight_out_Push_mioi_ccs_ccore_done_sync_vld = 0;
            weight_out_Push_mioi_oswt = 1;
            weight_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Test weight_out_Push_mioi_biwt activation (Sync and ready)");
            test_num = test_num + 1;
            PERun_wen = 0;
            weight_out_Push_mioi_bcwt = 0;
            weight_out_Push_mioi_ccs_ccore_done_sync_vld = 1;
            weight_out_Push_mioi_oswt = 1;
            weight_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Test start signal (sct) activation");
            test_num = test_num + 1;
            PERun_wen = 1;
            weight_out_Push_mioi_bcwt = 1;
            weight_out_Push_mioi_ccs_ccore_done_sync_vld = 0;
            weight_out_Push_mioi_oswt = 0;
            weight_out_Push_mioi_oswt_pff = 1;


            #1;



            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Test biwt inhibited by bcwt being high");
            test_num = test_num + 1;
            PERun_wen = 0;
            weight_out_Push_mioi_bcwt = 1;
            weight_out_Push_mioi_ccs_ccore_done_sync_vld = 1;
            weight_out_Push_mioi_oswt = 1;
            weight_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multiple signals active simultaneously");
            test_num = test_num + 1;
            PERun_wen = 1;
            weight_out_Push_mioi_bcwt = 0;
            weight_out_Push_mioi_ccs_ccore_done_sync_vld = 1;
            weight_out_Push_mioi_oswt = 1;
            weight_out_Push_mioi_oswt_pff = 1;





            #1;






            check_outputs(1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Partially active inputs (wen but no oswt)");
            test_num = test_num + 1;
            PERun_wen = 1;
            weight_out_Push_mioi_bcwt = 0;
            weight_out_Push_mioi_ccs_ccore_done_sync_vld = 1;
            weight_out_Push_mioi_oswt = 0;
            weight_out_Push_mioi_oswt_pff = 0;


            #1;



            check_outputs(0, 0, 0);
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
        input expected_weight_out_Push_mioi_bdwt;
        input expected_weight_out_Push_mioi_biwt;
        input expected_weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_weight_out_Push_mioi_bdwt === (expected_weight_out_Push_mioi_bdwt ^ weight_out_Push_mioi_bdwt ^ expected_weight_out_Push_mioi_bdwt) &&
                expected_weight_out_Push_mioi_biwt === (expected_weight_out_Push_mioi_biwt ^ weight_out_Push_mioi_biwt ^ expected_weight_out_Push_mioi_biwt) &&
                expected_weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct === (expected_weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct ^ weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct ^ expected_weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct)) begin
                $display("PASS");
                $display("  Outputs: weight_out_Push_mioi_bdwt=%b, weight_out_Push_mioi_biwt=%b, weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         weight_out_Push_mioi_bdwt, weight_out_Push_mioi_biwt, weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight_out_Push_mioi_bdwt=%b, weight_out_Push_mioi_biwt=%b, weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         expected_weight_out_Push_mioi_bdwt, expected_weight_out_Push_mioi_biwt, expected_weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
                $display("  Got:      weight_out_Push_mioi_bdwt=%b, weight_out_Push_mioi_biwt=%b, weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         weight_out_Push_mioi_bdwt, weight_out_Push_mioi_biwt, weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
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

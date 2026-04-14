`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PERun_wen;
    reg PERun_wten;
    reg weight_in_PopNB_mioi_oswt;
    reg weight_in_PopNB_mioi_oswt_pff;
    wire weight_in_PopNB_mioi_bdwt;
    wire weight_in_PopNB_mioi_biwt;
    wire weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PERun_wen(PERun_wen),
        .PERun_wten(PERun_wten),
        .weight_in_PopNB_mioi_oswt(weight_in_PopNB_mioi_oswt),
        .weight_in_PopNB_mioi_oswt_pff(weight_in_PopNB_mioi_oswt_pff),
        .weight_in_PopNB_mioi_bdwt(weight_in_PopNB_mioi_bdwt),
        .weight_in_PopNB_mioi_biwt(weight_in_PopNB_mioi_biwt),
        .weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct(weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All signals low - Idle state", test_num);
            PERun_wen = 0;
            PERun_wten = 0;
            weight_in_PopNB_mioi_oswt = 0;
            weight_in_PopNB_mioi_oswt_pff = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SCT Enable - PERun_wen and oswt high", test_num);
            PERun_wen = 1;
            PERun_wten = 0;
            weight_in_PopNB_mioi_oswt = 1;
            weight_in_PopNB_mioi_oswt_pff = 0;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BIWT Enable - PERun_wten and oswt_pff high", test_num);
            PERun_wen = 0;
            PERun_wten = 1;
            weight_in_PopNB_mioi_oswt = 0;
            weight_in_PopNB_mioi_oswt_pff = 1;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BDWT Enable - PERun_wten low and oswt_pff high", test_num);
            PERun_wen = 0;
            PERun_wten = 0;
            weight_in_PopNB_mioi_oswt = 0;
            weight_in_PopNB_mioi_oswt_pff = 1;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Condition - oswt high without wen", test_num);
            PERun_wen = 0;
            PERun_wten = 0;
            weight_in_PopNB_mioi_oswt = 1;
            weight_in_PopNB_mioi_oswt_pff = 0;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Active State - Both enables and control high", test_num);
            PERun_wen = 1;
            PERun_wten = 1;
            weight_in_PopNB_mioi_oswt = 1;
            weight_in_PopNB_mioi_oswt_pff = 1;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control mismatch - wen high but oswt low", test_num);
            PERun_wen = 1;
            PERun_wten = 1;
            weight_in_PopNB_mioi_oswt = 0;
            weight_in_PopNB_mioi_oswt_pff = 0;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write Disable sequence - wen high and oswt_pff high", test_num);
            PERun_wen = 1;
            PERun_wten = 0;
            weight_in_PopNB_mioi_oswt = 0;
            weight_in_PopNB_mioi_oswt_pff = 1;

            #1;


            check_outputs(1, 0, 0);
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
        input expected_weight_in_PopNB_mioi_bdwt;
        input expected_weight_in_PopNB_mioi_biwt;
        input expected_weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_weight_in_PopNB_mioi_bdwt === (expected_weight_in_PopNB_mioi_bdwt ^ weight_in_PopNB_mioi_bdwt ^ expected_weight_in_PopNB_mioi_bdwt) &&
                expected_weight_in_PopNB_mioi_biwt === (expected_weight_in_PopNB_mioi_biwt ^ weight_in_PopNB_mioi_biwt ^ expected_weight_in_PopNB_mioi_biwt) &&
                expected_weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct === (expected_weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct ^ weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct ^ expected_weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct)) begin
                $display("PASS");
                $display("  Outputs: weight_in_PopNB_mioi_bdwt=%b, weight_in_PopNB_mioi_biwt=%b, weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         weight_in_PopNB_mioi_bdwt, weight_in_PopNB_mioi_biwt, weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight_in_PopNB_mioi_bdwt=%b, weight_in_PopNB_mioi_biwt=%b, weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         expected_weight_in_PopNB_mioi_bdwt, expected_weight_in_PopNB_mioi_biwt, expected_weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
                $display("  Got:      weight_in_PopNB_mioi_bdwt=%b, weight_in_PopNB_mioi_biwt=%b, weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         weight_in_PopNB_mioi_bdwt, weight_in_PopNB_mioi_biwt, weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
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

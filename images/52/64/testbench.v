`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PERun_wen;
    reg PERun_wten;
    reg act_in_PopNB_mioi_oswt;
    reg act_in_PopNB_mioi_oswt_pff;
    wire act_in_PopNB_mioi_bdwt;
    wire act_in_PopNB_mioi_biwt;
    wire act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PERun_wen(PERun_wen),
        .PERun_wten(PERun_wten),
        .act_in_PopNB_mioi_oswt(act_in_PopNB_mioi_oswt),
        .act_in_PopNB_mioi_oswt_pff(act_in_PopNB_mioi_oswt_pff),
        .act_in_PopNB_mioi_bdwt(act_in_PopNB_mioi_bdwt),
        .act_in_PopNB_mioi_biwt(act_in_PopNB_mioi_biwt),
        .act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct(act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            PERun_wen = 0;
            PERun_wten = 0;
            act_in_PopNB_mioi_oswt = 0;
            act_in_PopNB_mioi_oswt_pff = 0;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State active, but write control low", test_num);
            PERun_wen = 0;
            PERun_wten = 1;
            act_in_PopNB_mioi_oswt = 1;
            act_in_PopNB_mioi_oswt_pff = 1;




            #1;





            check_outputs(0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State active, write enable and tenability high", test_num);
            PERun_wen = 1;
            PERun_wten = 1;
            act_in_PopNB_mioi_oswt = 1;
            act_in_PopNB_mioi_oswt_pff = 1;




            #1;





            check_outputs(1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State active, tenability inactive (wait condition)", test_num);
            PERun_wen = 0;
            PERun_wten = 0;
            act_in_PopNB_mioi_oswt = 1;
            act_in_PopNB_mioi_oswt_pff = 1;




            #1;





            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State active, write enable high, tenability inactive", test_num);
            PERun_wen = 1;
            PERun_wten = 0;
            act_in_PopNB_mioi_oswt = 1;
            act_in_PopNB_mioi_oswt_pff = 1;




            #1;





            check_outputs(1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State inactive, control signals ignored", test_num);
            PERun_wen = 1;
            PERun_wten = 0;
            act_in_PopNB_mioi_oswt = 0;
            act_in_PopNB_mioi_oswt_pff = 0;




            #1;





            check_outputs(0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: State transition check (oswt high, pff low)", test_num);
            PERun_wen = 1;
            PERun_wten = 1;
            act_in_PopNB_mioi_oswt = 1;
            act_in_PopNB_mioi_oswt_pff = 0;




            #1;





            check_outputs(1, 0, 1);
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
        input expected_act_in_PopNB_mioi_bdwt;
        input expected_act_in_PopNB_mioi_biwt;
        input expected_act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_act_in_PopNB_mioi_bdwt === (expected_act_in_PopNB_mioi_bdwt ^ act_in_PopNB_mioi_bdwt ^ expected_act_in_PopNB_mioi_bdwt) &&
                expected_act_in_PopNB_mioi_biwt === (expected_act_in_PopNB_mioi_biwt ^ act_in_PopNB_mioi_biwt ^ expected_act_in_PopNB_mioi_biwt) &&
                expected_act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct === (expected_act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct ^ act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct ^ expected_act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct)) begin
                $display("PASS");
                $display("  Outputs: act_in_PopNB_mioi_bdwt=%b, act_in_PopNB_mioi_biwt=%b, act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         act_in_PopNB_mioi_bdwt, act_in_PopNB_mioi_biwt, act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: act_in_PopNB_mioi_bdwt=%b, act_in_PopNB_mioi_biwt=%b, act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         expected_act_in_PopNB_mioi_bdwt, expected_act_in_PopNB_mioi_biwt, expected_act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
                $display("  Got:      act_in_PopNB_mioi_bdwt=%b, act_in_PopNB_mioi_biwt=%b, act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct=%b",
                         act_in_PopNB_mioi_bdwt, act_in_PopNB_mioi_biwt, act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct);
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

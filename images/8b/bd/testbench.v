`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg arst_l;
    reg ctu_tst_macrotest;
    reg ctu_tst_pre_grst_l;
    reg ctu_tst_scan_disable;
    reg ctu_tst_scanmode;
    reg ctu_tst_short_chain;
    reg global_shift_enable;
    reg long_chain_so_0;
    reg long_chain_so_1;
    reg long_chain_so_2;
    reg short_chain_so_0;
    reg short_chain_so_1;
    reg short_chain_so_2;
    wire mem_bypass;
    wire mem_write_disable;
    wire mux_drive_disable;
    wire se;
    wire sehold;
    wire so_0;
    wire so_1;
    wire so_2;
    wire testmode_l;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arst_l(arst_l),
        .ctu_tst_macrotest(ctu_tst_macrotest),
        .ctu_tst_pre_grst_l(ctu_tst_pre_grst_l),
        .ctu_tst_scan_disable(ctu_tst_scan_disable),
        .ctu_tst_scanmode(ctu_tst_scanmode),
        .ctu_tst_short_chain(ctu_tst_short_chain),
        .global_shift_enable(global_shift_enable),
        .long_chain_so_0(long_chain_so_0),
        .long_chain_so_1(long_chain_so_1),
        .long_chain_so_2(long_chain_so_2),
        .short_chain_so_0(short_chain_so_0),
        .short_chain_so_1(short_chain_so_1),
        .short_chain_so_2(short_chain_so_2),
        .mem_bypass(mem_bypass),
        .mem_write_disable(mem_write_disable),
        .mux_drive_disable(mux_drive_disable),
        .se(se),
        .sehold(sehold),
        .so_0(so_0),
        .so_1(so_1),
        .so_2(so_2),
        .testmode_l(testmode_l)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All inputs at reset/inactive", test_num);

            arst_l = 0;
            ctu_tst_pre_grst_l = 0;
            global_shift_enable = 0;
            ctu_tst_scan_disable = 1;
            ctu_tst_scanmode = 0;
            ctu_tst_macrotest = 0;
            ctu_tst_short_chain = 0;
            long_chain_so_0 = 0; long_chain_so_1 = 0; long_chain_so_2 = 0;
            short_chain_so_0 = 0; short_chain_so_1 = 0; short_chain_so_2 = 0;


            #1;



            check_outputs(0, 0, 0, 0, 1, 0, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Scan Mode Active, Long Chain Selection", test_num);
            arst_l = 1;
            ctu_tst_pre_grst_l = 1;
            global_shift_enable = 1;
            ctu_tst_scan_disable = 0;
            ctu_tst_scanmode = 1;
            ctu_tst_macrotest = 0;
            ctu_tst_short_chain = 0;
            long_chain_so_0 = 1; long_chain_so_1 = 0; long_chain_so_2 = 1;
            short_chain_so_0 = 0; short_chain_so_1 = 1; short_chain_so_2 = 0;


            #1;



            check_outputs(1, 1, 1, 1, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Scan Mode Active, Short Chain Selection", test_num);
            arst_l = 1;
            ctu_tst_pre_grst_l = 1;
            global_shift_enable = 1;
            ctu_tst_scan_disable = 0;
            ctu_tst_scanmode = 1;
            ctu_tst_macrotest = 0;
            ctu_tst_short_chain = 1;
            long_chain_so_0 = 1; long_chain_so_1 = 0; long_chain_so_2 = 1;
            short_chain_so_0 = 0; short_chain_so_1 = 1; short_chain_so_2 = 0;


            #1;



            check_outputs(1, 1, 1, 1, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Scan Disable Override of Shift Enable", test_num);
            arst_l = 1;
            ctu_tst_pre_grst_l = 1;
            global_shift_enable = 1;
            ctu_tst_scan_disable = 1;
            ctu_tst_scanmode = 1;
            ctu_tst_macrotest = 0;
            ctu_tst_short_chain = 0;
            long_chain_so_0 = 1; long_chain_so_1 = 1; long_chain_so_2 = 1;


            #1;



            check_outputs(1, 1, 0, 0, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Macro Test Mode Active", test_num);
            arst_l = 1;
            ctu_tst_pre_grst_l = 1;
            global_shift_enable = 0;
            ctu_tst_scan_disable = 0;
            ctu_tst_scanmode = 0;
            ctu_tst_macrotest = 1;
            ctu_tst_short_chain = 0;
            long_chain_so_0 = 0; long_chain_so_1 = 1; long_chain_so_2 = 0;


            #1;



            check_outputs(1, 0, 0, 0, 1, 0, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Data Toggle Verification (Short Chain)", test_num);
            arst_l = 1;
            ctu_tst_pre_grst_l = 1;
            ctu_tst_scanmode = 1;
            ctu_tst_short_chain = 1;


            short_chain_so_0 = 1; short_chain_so_1 = 1; short_chain_so_2 = 1;
            #2;
            if(so_0 === 1 && so_1 === 1 && so_2 === 1) pass_count++; else fail_count++;


            short_chain_so_0 = 0; short_chain_so_1 = 0; short_chain_so_2 = 0;
            #2;
            if(so_0 === 0 && so_1 === 0 && so_2 === 0) pass_count++; else fail_count++;


            #1;



            check_outputs(1, 1, 1, 0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Global Shift Enable Inactive", test_num);
            arst_l = 1;
            ctu_tst_pre_grst_l = 1;
            global_shift_enable = 0;
            ctu_tst_scan_disable = 0;
            ctu_tst_scanmode = 1;
            ctu_tst_short_chain = 0;
            long_chain_so_0 = 1; long_chain_so_1 = 0; long_chain_so_2 = 1;


            #1;



            check_outputs(1, 1, 1, 0, 1, 1, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Assertion of arst_l during operation", test_num);

            arst_l = 1; ctu_tst_pre_grst_l = 1;
            ctu_tst_scanmode = 1;
            #5;

            arst_l = 0;
            #5;


            #1;



            check_outputs(0, 0, 0, 0, 1, 0, 0, 0, 1);
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
        input expected_mem_bypass;
        input expected_mem_write_disable;
        input expected_mux_drive_disable;
        input expected_se;
        input expected_sehold;
        input expected_so_0;
        input expected_so_1;
        input expected_so_2;
        input expected_testmode_l;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_bypass === (expected_mem_bypass ^ mem_bypass ^ expected_mem_bypass) &&
                expected_mem_write_disable === (expected_mem_write_disable ^ mem_write_disable ^ expected_mem_write_disable) &&
                expected_mux_drive_disable === (expected_mux_drive_disable ^ mux_drive_disable ^ expected_mux_drive_disable) &&
                expected_se === (expected_se ^ se ^ expected_se) &&
                expected_sehold === (expected_sehold ^ sehold ^ expected_sehold) &&
                expected_so_0 === (expected_so_0 ^ so_0 ^ expected_so_0) &&
                expected_so_1 === (expected_so_1 ^ so_1 ^ expected_so_1) &&
                expected_so_2 === (expected_so_2 ^ so_2 ^ expected_so_2) &&
                expected_testmode_l === (expected_testmode_l ^ testmode_l ^ expected_testmode_l)) begin
                $display("PASS");
                $display("  Outputs: mem_bypass=%b, mem_write_disable=%b, mux_drive_disable=%b, se=%b, sehold=%b, so_0=%b, so_1=%b, so_2=%b, testmode_l=%b",
                         mem_bypass, mem_write_disable, mux_drive_disable, se, sehold, so_0, so_1, so_2, testmode_l);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_bypass=%b, mem_write_disable=%b, mux_drive_disable=%b, se=%b, sehold=%b, so_0=%b, so_1=%b, so_2=%b, testmode_l=%b",
                         expected_mem_bypass, expected_mem_write_disable, expected_mux_drive_disable, expected_se, expected_sehold, expected_so_0, expected_so_1, expected_so_2, expected_testmode_l);
                $display("  Got:      mem_bypass=%b, mem_write_disable=%b, mux_drive_disable=%b, se=%b, sehold=%b, so_0=%b, so_1=%b, so_2=%b, testmode_l=%b",
                         mem_bypass, mem_write_disable, mux_drive_disable, se, sehold, so_0, so_1, so_2, testmode_l);
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

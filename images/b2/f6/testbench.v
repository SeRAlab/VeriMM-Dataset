`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctu_tst_scan_disable;
    reg ctu_tst_short_chain;
    reg global_shift_enable;
    reg long_chain_so_0;
    reg short_chain_so_0;
    wire se;
    wire so_0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctu_tst_scan_disable(ctu_tst_scan_disable),
        .ctu_tst_short_chain(ctu_tst_short_chain),
        .global_shift_enable(global_shift_enable),
        .long_chain_so_0(long_chain_so_0),
        .short_chain_so_0(short_chain_so_0),
        .se(se),
        .so_0(so_0)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking Scan Enable HIGH path", test_num);
            ctu_tst_scan_disable = 1'b0;
            global_shift_enable = 1'b1;
            ctu_tst_short_chain = 1'b0;
            long_chain_so_0 = 1'b0;
            short_chain_so_0 = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking Scan Disable logic (se should be 0)", test_num);
            ctu_tst_scan_disable = 1'b1;
            global_shift_enable = 1'b1;
            ctu_tst_short_chain = 1'b0;
            long_chain_so_0 = 1'b1;
            short_chain_so_0 = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking Global Shift Disable (se should be 0)", test_num);
            ctu_tst_scan_disable = 1'b0;
            global_shift_enable = 1'b0;
            ctu_tst_short_chain = 1'b1;
            long_chain_so_0 = 1'b0;
            short_chain_so_0 = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Short Chain Data Path (Select=1, Input=1)", test_num);
            ctu_tst_scan_disable = 1'b0;
            global_shift_enable = 1'b1;
            ctu_tst_short_chain = 1'b1;
            short_chain_so_0 = 1'b1;
            long_chain_so_0 = 1'b0;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Short Chain Data Path (Select=1, Input=0)", test_num);
            ctu_tst_scan_disable = 1'b0;
            global_shift_enable = 1'b1;
            ctu_tst_short_chain = 1'b1;
            short_chain_so_0 = 1'b0;
            long_chain_so_0 = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long Chain Data Path (Select=0, Input=1)", test_num);
            ctu_tst_scan_disable = 1'b0;
            global_shift_enable = 1'b1;
            ctu_tst_short_chain = 1'b0;
            short_chain_so_0 = 1'b0;
            long_chain_so_0 = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long Chain Data Path (Select=0, Input=0)", test_num);
            ctu_tst_scan_disable = 1'b0;
            global_shift_enable = 1'b1;
            ctu_tst_short_chain = 1'b0;
            short_chain_so_0 = 1'b1;
            long_chain_so_0 = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long Chain selection with changing short chain input", test_num);
            ctu_tst_scan_disable = 1'b0;
            global_shift_enable = 1'b1;
            ctu_tst_short_chain = 1'b0;
            long_chain_so_0 = 1'b1;
            short_chain_so_0 = 1'b0;
            #1;
            short_chain_so_0 = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1);
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
        input expected_se;
        input expected_so_0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_se === (expected_se ^ se ^ expected_se) &&
                expected_so_0 === (expected_so_0 ^ so_0 ^ expected_so_0)) begin
                $display("PASS");
                $display("  Outputs: se=%b, so_0=%b",
                         se, so_0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: se=%b, so_0=%b",
                         expected_se, expected_so_0);
                $display("  Got:      se=%b, so_0=%b",
                         se, so_0);
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

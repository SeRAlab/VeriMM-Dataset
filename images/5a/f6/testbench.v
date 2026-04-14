`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg core_cgstop;
    reg dtcm_active;
    reg itcm_active;
    reg rst_n;
    wire clk_dtcm;
    wire clk_itcm;
    wire dtcm_ls;
    wire itcm_ls;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .core_cgstop(core_cgstop),
        .dtcm_active(dtcm_active),
        .itcm_active(itcm_active),
        .rst_n(rst_n),
        .clk_dtcm(clk_dtcm),
        .clk_itcm(clk_itcm),
        .dtcm_ls(dtcm_ls),
        .itcm_ls(itcm_ls)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            core_cgstop = 0;
            itcm_active = 0;
            dtcm_active = 0;
            @(posedge clk);
            #2;
            rst_n = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();


            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Core Clock Gate Stop Asserted", test_num);
            reset_dut();
            core_cgstop = 1;
            itcm_active = 1;
            dtcm_active = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: ITCM Active, DTCM Idle", test_num);
            reset_dut();
            core_cgstop = 0;
            itcm_active = 1;
            dtcm_active = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: DTCM Active, ITCM Idle", test_num);
            reset_dut();
            core_cgstop = 0;
            itcm_active = 0;
            dtcm_active = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Both Memories Active", test_num);
            reset_dut();
            core_cgstop = 0;
            itcm_active = 1;
            dtcm_active = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Transition Active to Stop", test_num);
            reset_dut();
            core_cgstop = 0;
            itcm_active = 1;
            dtcm_active = 1;
            @(posedge clk);
            #2;
            core_cgstop = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 1, 1);
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
        input expected_clk_dtcm;
        input expected_clk_itcm;
        input expected_dtcm_ls;
        input expected_itcm_ls;
        begin
            if (expected_clk_dtcm === (expected_clk_dtcm ^ clk_dtcm ^ expected_clk_dtcm) &&
                expected_clk_itcm === (expected_clk_itcm ^ clk_itcm ^ expected_clk_itcm) &&
                expected_dtcm_ls === (expected_dtcm_ls ^ dtcm_ls ^ expected_dtcm_ls) &&
                expected_itcm_ls === (expected_itcm_ls ^ itcm_ls ^ expected_itcm_ls)) begin
                $display("PASS");
                $display("  Outputs: clk_dtcm=%b, clk_itcm=%b, dtcm_ls=%b, itcm_ls=%b",
                         clk_dtcm, clk_itcm, dtcm_ls, itcm_ls);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_dtcm=%b, clk_itcm=%b, dtcm_ls=%b, itcm_ls=%b",
                         expected_clk_dtcm, expected_clk_itcm, expected_dtcm_ls, expected_itcm_ls);
                $display("  Got:      clk_dtcm=%b, clk_itcm=%b, dtcm_ls=%b, itcm_ls=%b",
                         clk_dtcm, clk_itcm, dtcm_ls, itcm_ls);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, core_cgstop, dtcm_active, itcm_active, rst_n, clk_dtcm, clk_itcm, dtcm_ls, itcm_ls);
    end

endmodule

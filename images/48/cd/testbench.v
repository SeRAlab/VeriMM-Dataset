`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg LP_N;
    reg LP_P;
    reg RESET_n;
    wire HS_MODE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .LP_N(LP_N),
        .LP_P(LP_P),
        .RESET_n(RESET_n),
        .HS_MODE(HS_MODE)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET_n = 0;
            LP_P = 1;
            LP_N = 1;
            repeat(2) @(posedge CLK);
            #1;
            RESET_n = 1;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: HS Entry Sequence (LP-11 -> LP-01 -> LP-00)", test_num);
            reset_dut();


            LP_P = 0; LP_N = 1;
            @(posedge CLK);


            LP_P = 0; LP_N = 0;
            @(posedge CLK);


            repeat(2) @(posedge CLK);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Remain in LP-11 Idle", test_num);
            reset_dut();

            LP_P = 1; LP_N = 1;
            repeat(5) @(posedge CLK);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Incomplete Sequence (11 -> 01 -> 11)", test_num);
            reset_dut();


            LP_P = 0; LP_N = 1;
            @(posedge CLK);


            LP_P = 1; LP_N = 1;
            @(posedge CLK);

            repeat(2) @(posedge CLK);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: HS Exit Sequence", test_num);
            reset_dut();


            LP_P = 0; LP_N = 1; @(posedge CLK);
            LP_P = 0; LP_N = 0; @(posedge CLK);
            repeat(2) @(posedge CLK);


            LP_P = 1; LP_N = 1;
            repeat(2) @(posedge CLK);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Invalid Transition Sequence (11 -> 10 -> 00)", test_num);
            reset_dut();


            LP_P = 1; LP_N = 0;
            @(posedge CLK);
            LP_P = 0; LP_N = 0;
            @(posedge CLK);

            repeat(2) @(posedge CLK);
            #1;

            check_outputs(1'b0);
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
        input expected_HS_MODE;
        begin
            if (expected_HS_MODE === (expected_HS_MODE ^ HS_MODE ^ expected_HS_MODE)) begin
                $display("PASS");
                $display("  Outputs: HS_MODE=%b",
                         HS_MODE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HS_MODE=%b",
                         expected_HS_MODE);
                $display("  Got:      HS_MODE=%b",
                         HS_MODE);
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
        $dumpvars(0,CLK, LP_N, LP_P, RESET_n, HS_MODE);
    end

endmodule

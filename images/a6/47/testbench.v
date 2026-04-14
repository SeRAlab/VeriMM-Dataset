`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RX_NEG;
    reg RX_SP;
    reg USER_CLK;
    reg ack_r;
    reg count_128d_done_r;
    reg polarity_r;
    reg ready_r;
    wire RX_POLARITY;
    wire remote_reset_watchdog_done_r;
    wire sp_polarity_c;
    wire watchdog_done_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RX_NEG(RX_NEG),
        .RX_SP(RX_SP),
        .USER_CLK(USER_CLK),
        .ack_r(ack_r),
        .count_128d_done_r(count_128d_done_r),
        .polarity_r(polarity_r),
        .ready_r(ready_r),
        .RX_POLARITY(RX_POLARITY),
        .remote_reset_watchdog_done_r(remote_reset_watchdog_done_r),
        .sp_polarity_c(sp_polarity_c),
        .watchdog_done_r(watchdog_done_r)
    );

    // Clock generation (10ns period)
    initial begin
        USER_CLK = 0;
        forever #5 USER_CLK = ~USER_CLK;
    end

        task reset_dut;

        begin
            RX_NEG = 0;
            RX_SP = 0;
            ack_r = 0;
            count_128d_done_r = 0;
            polarity_r = 0;
            ready_r = 0;
            wait_cycles(5);
        end
        endtask
    task wait_cycles;

        input integer cycles;
        begin
            repeat(cycles) @(posedge USER_CLK);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase 001: Initial state check");
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase 002: Triggering Watchdog Done (16 shifts)");
            reset_dut();
            ready_r = 1;
            ack_r = 0;
            wait_cycles(16);

            #1;


            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase 003: Triggering Remote Reset Watchdog");
            reset_dut();
            ready_r = 1;
            ack_r = 1;
            wait_cycles(16);
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase 004: RX_SP Reset function");
            reset_dut();
            ready_r = 1;
            wait_cycles(16);


            RX_SP = 1;
            wait_cycles(1);
            RX_SP = 0;
            wait_cycles(1);


            #1;



            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase 005: Polarity control and RX_NEG");
            reset_dut();
            RX_NEG = 1;
            polarity_r = 1;
            count_128d_done_r = 1;
            wait_cycles(2);



            #1;




            check_outputs(1, 0, 1, 0);
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
        input expected_RX_POLARITY;
        input expected_remote_reset_watchdog_done_r;
        input expected_sp_polarity_c;
        input expected_watchdog_done_r;
        begin
            if (expected_RX_POLARITY === (expected_RX_POLARITY ^ RX_POLARITY ^ expected_RX_POLARITY) &&
                expected_remote_reset_watchdog_done_r === (expected_remote_reset_watchdog_done_r ^ remote_reset_watchdog_done_r ^ expected_remote_reset_watchdog_done_r) &&
                expected_sp_polarity_c === (expected_sp_polarity_c ^ sp_polarity_c ^ expected_sp_polarity_c) &&
                expected_watchdog_done_r === (expected_watchdog_done_r ^ watchdog_done_r ^ expected_watchdog_done_r)) begin
                $display("PASS");
                $display("  Outputs: RX_POLARITY=%b, remote_reset_watchdog_done_r=%b, sp_polarity_c=%b, watchdog_done_r=%b",
                         RX_POLARITY, remote_reset_watchdog_done_r, sp_polarity_c, watchdog_done_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RX_POLARITY=%b, remote_reset_watchdog_done_r=%b, sp_polarity_c=%b, watchdog_done_r=%b",
                         expected_RX_POLARITY, expected_remote_reset_watchdog_done_r, expected_sp_polarity_c, expected_watchdog_done_r);
                $display("  Got:      RX_POLARITY=%b, remote_reset_watchdog_done_r=%b, sp_polarity_c=%b, watchdog_done_r=%b",
                         RX_POLARITY, remote_reset_watchdog_done_r, sp_polarity_c, watchdog_done_r);
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
        $dumpvars(0,RX_NEG, RX_SP, USER_CLK, ack_r, count_128d_done_r, polarity_r, ready_r, RX_POLARITY, remote_reset_watchdog_done_r, sp_polarity_c, watchdog_done_r);
    end

endmodule

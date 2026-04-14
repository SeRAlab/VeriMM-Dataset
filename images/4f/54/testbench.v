`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg En;
    reg reset_n;
    wire [3:0] BCD_hsec;
    wire [3:0] BCD_msec;
    wire [3:0] BCD_sec;
    wire [3:0] BCD_tsec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .En(En),
        .reset_n(reset_n),
        .BCD_hsec(BCD_hsec),
        .BCD_msec(BCD_msec),
        .BCD_sec(BCD_sec),
        .BCD_tsec(BCD_tsec)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            reset_n = 0;
            En = 0;
            @(posedge Clock);
            #1;
            reset_n = 1;
            @(posedge Clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic increment (5ms)", test_num);
            reset_dut();
            En = 1;
            repeat (5) @(posedge Clock);
            En = 0;
            @(posedge Clock);

            #1;


            check_outputs(4'd0, 4'd5, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rollover msec -> hsec (15ms)", test_num);
            reset_dut();
            En = 1;
            repeat (15) @(posedge Clock);
            En = 0;
            @(posedge Clock);

            #1;


            check_outputs(4'd1, 4'd5, 4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rollover to tsec (150ms)", test_num);
            reset_dut();
            En = 1;
            repeat (150) @(posedge Clock);
            En = 0;
            @(posedge Clock);

            #1;


            check_outputs(4'd5, 4'd0, 4'd0, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full second rollover (1000ms)", test_num);
            reset_dut();
            En = 1;
            repeat (1000) @(posedge Clock);
            En = 0;
            @(posedge Clock);

            #1;


            check_outputs(4'd0, 4'd0, 4'd1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex count (1234ms)", test_num);
            reset_dut();
            En = 1;
            repeat (1234) @(posedge Clock);
            En = 0;
            @(posedge Clock);

            #1;


            check_outputs(4'd3, 4'd4, 4'd1, 4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable signal pause check", test_num);
            reset_dut();
            En = 1;
            repeat (10) @(posedge Clock);
            En = 0;
            repeat (20) @(posedge Clock);

            #1;


            check_outputs(4'd1, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum rollover (9999 -> 10000)", test_num);
            reset_dut();
            En = 1;
            repeat (9999) @(posedge Clock);

            if (BCD_sec == 9 && BCD_tsec == 9 && BCD_hsec == 9 && BCD_msec == 9)
                $display("  Reached 9.999 correctly");

            repeat (1) @(posedge Clock);
            En = 0;
            @(posedge Clock);

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
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
        input [3:0] expected_BCD_hsec;
        input [3:0] expected_BCD_msec;
        input [3:0] expected_BCD_sec;
        input [3:0] expected_BCD_tsec;
        begin
            if (expected_BCD_hsec === (expected_BCD_hsec ^ BCD_hsec ^ expected_BCD_hsec) &&
                expected_BCD_msec === (expected_BCD_msec ^ BCD_msec ^ expected_BCD_msec) &&
                expected_BCD_sec === (expected_BCD_sec ^ BCD_sec ^ expected_BCD_sec) &&
                expected_BCD_tsec === (expected_BCD_tsec ^ BCD_tsec ^ expected_BCD_tsec)) begin
                $display("PASS");
                $display("  Outputs: BCD_hsec=%h, BCD_msec=%h, BCD_sec=%h, BCD_tsec=%h",
                         BCD_hsec, BCD_msec, BCD_sec, BCD_tsec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD_hsec=%h, BCD_msec=%h, BCD_sec=%h, BCD_tsec=%h",
                         expected_BCD_hsec, expected_BCD_msec, expected_BCD_sec, expected_BCD_tsec);
                $display("  Got:      BCD_hsec=%h, BCD_msec=%h, BCD_sec=%h, BCD_tsec=%h",
                         BCD_hsec, BCD_msec, BCD_sec, BCD_tsec);
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
        $dumpvars(0,Clock, En, reset_n, BCD_hsec, BCD_msec, BCD_sec, BCD_tsec);
    end

endmodule

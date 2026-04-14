`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] hour1;
    reg [3:0] hour2;
    reg [3:0] minute1;
    reg [3:0] minute2;
    reg nLoad;
    reg [3:0] second1;
    reg [3:0] second2;
    wire [3:0] chour1;
    wire [3:0] chour2;
    wire [3:0] cminute1;
    wire [3:0] cminute2;
    wire [3:0] csecond1;
    wire [3:0] csecond2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .hour1(hour1),
        .hour2(hour2),
        .minute1(minute1),
        .minute2(minute2),
        .nLoad(nLoad),
        .second1(second1),
        .second2(second2),
        .chour1(chour1),
        .chour2(chour2),
        .cminute1(cminute1),
        .cminute2(cminute2),
        .csecond1(csecond1),
        .csecond2(csecond2)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            nLoad = 0;
            hour1 = 0; hour2 = 0;
            minute1 = 0; minute2 = 0;
            second1 = 0; second2 = 0;
            @(posedge Clk);
            #1;
            nLoad = 1;
        end
        endtask
    task load_time;

        input [3:0] h2, h1, m2, m1, s2, s1;
        begin
            nLoad = 0;
            hour2 = h2; hour1 = h1;
            minute2 = m2; minute1 = m1;
            second2 = s2; second1 = s1;
            @(posedge Clk);
            #1;
            nLoad = 1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Loading initial time 12:34:56", test_num);
            reset_dut();
            load_time(1, 2, 3, 4, 5, 6);

            #1;


            check_outputs(2, 1, 4, 3, 6, 5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Seconds Rollover (00:00:59 -> 00:01:00)", test_num);
            reset_dut();
            load_time(0, 0, 0, 0, 5, 9);
            @(posedge Clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Minutes Rollover (00:59:59 -> 01:00:00)", test_num);
            reset_dut();
            load_time(0, 0, 5, 9, 5, 9);
            @(posedge Clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Hours Units Rollover (09:59:59 -> 10:00:00)", test_num);
            reset_dut();
            load_time(0, 9, 5, 9, 5, 9);
            @(posedge Clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Day Rollover (23:59:59 -> 00:00:00)", test_num);
            reset_dut();
            load_time(2, 3, 5, 9, 5, 9);
            @(posedge Clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("\nTestcase %0d: Incrementing 10 seconds (00:00:00 -> 00:00:10)", test_num);
            reset_dut();
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge Clk);
            end
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 1);
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
        input [3:0] expected_chour1;
        input [3:0] expected_chour2;
        input [3:0] expected_cminute1;
        input [3:0] expected_cminute2;
        input [3:0] expected_csecond1;
        input [3:0] expected_csecond2;
        begin
            if (expected_chour1 === (expected_chour1 ^ chour1 ^ expected_chour1) &&
                expected_chour2 === (expected_chour2 ^ chour2 ^ expected_chour2) &&
                expected_cminute1 === (expected_cminute1 ^ cminute1 ^ expected_cminute1) &&
                expected_cminute2 === (expected_cminute2 ^ cminute2 ^ expected_cminute2) &&
                expected_csecond1 === (expected_csecond1 ^ csecond1 ^ expected_csecond1) &&
                expected_csecond2 === (expected_csecond2 ^ csecond2 ^ expected_csecond2)) begin
                $display("PASS");
                $display("  Outputs: chour1=%h, chour2=%h, cminute1=%h, cminute2=%h, csecond1=%h, csecond2=%h",
                         chour1, chour2, cminute1, cminute2, csecond1, csecond2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: chour1=%h, chour2=%h, cminute1=%h, cminute2=%h, csecond1=%h, csecond2=%h",
                         expected_chour1, expected_chour2, expected_cminute1, expected_cminute2, expected_csecond1, expected_csecond2);
                $display("  Got:      chour1=%h, chour2=%h, cminute1=%h, cminute2=%h, csecond1=%h, csecond2=%h",
                         chour1, chour2, cminute1, cminute2, csecond1, csecond2);
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
        $dumpvars(0,Clk, hour1, hour2, minute1, minute2, nLoad, second1, second2, chour1, chour2, cminute1, cminute2, csecond1, csecond2);
    end

endmodule

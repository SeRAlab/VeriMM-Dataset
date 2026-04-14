`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] hours_in;
    reg [7:0] minutes_in;
    reg [7:0] seconds_in;
    wire PM_LED;
    wire [7:0] hours_out;
    wire [7:0] minutes_out;
    wire [7:0] seconds_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hours_in(hours_in),
        .minutes_in(minutes_in),
        .seconds_in(seconds_in),
        .PM_LED(PM_LED),
        .hours_out(hours_out),
        .minutes_out(minutes_out),
        .seconds_out(seconds_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Midnight (00:00:00)", test_num);
        hours_in = 8'd0;
        minutes_in = 8'd0;
        seconds_in = 8'd0;

        #1;


        check_outputs(1'b0, 8'd12, 8'd0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Early Morning (01:15:30)", test_num);
        hours_in = 8'd1;
        minutes_in = 8'd15;
        seconds_in = 8'd30;

        #1;


        check_outputs(1'b0, 8'd1, 8'd15, 8'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Late Morning (11:59:59)", test_num);
        hours_in = 8'd11;
        minutes_in = 8'd59;
        seconds_in = 8'd59;

        #1;


        check_outputs(1'b0, 8'd11, 8'd59, 8'd59);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Noon (12:00:00)", test_num);
        hours_in = 8'd12;
        minutes_in = 8'd0;
        seconds_in = 8'd0;

        #1;


        check_outputs(1'b1, 8'd12, 8'd0, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Early Afternoon (13:05:10)", test_num);
        hours_in = 8'd13;
        minutes_in = 8'd5;
        seconds_in = 8'd10;

        #1;


        check_outputs(1'b1, 8'd1, 8'd5, 8'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Late Evening (23:59:59)", test_num);
        hours_in = 8'd23;
        minutes_in = 8'd59;
        seconds_in = 8'd59;

        #1;


        check_outputs(1'b1, 8'd11, 8'd59, 8'd59);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: PM transition edge (12:00:01)", test_num);
        hours_in = 8'd12;
        minutes_in = 8'd0;
        seconds_in = 8'd1;

        #1;


        check_outputs(1'b1, 8'd12, 8'd0, 8'd1);
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
        input expected_PM_LED;
        input [7:0] expected_hours_out;
        input [7:0] expected_minutes_out;
        input [7:0] expected_seconds_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PM_LED === (expected_PM_LED ^ PM_LED ^ expected_PM_LED) &&
                expected_hours_out === (expected_hours_out ^ hours_out ^ expected_hours_out) &&
                expected_minutes_out === (expected_minutes_out ^ minutes_out ^ expected_minutes_out) &&
                expected_seconds_out === (expected_seconds_out ^ seconds_out ^ expected_seconds_out)) begin
                $display("PASS");
                $display("  Outputs: PM_LED=%b, hours_out=%h, minutes_out=%h, seconds_out=%h",
                         PM_LED, hours_out, minutes_out, seconds_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PM_LED=%b, hours_out=%h, minutes_out=%h, seconds_out=%h",
                         expected_PM_LED, expected_hours_out, expected_minutes_out, expected_seconds_out);
                $display("  Got:      PM_LED=%b, hours_out=%h, minutes_out=%h, seconds_out=%h",
                         PM_LED, hours_out, minutes_out, seconds_out);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] time_now;
    reg [63:0] trigger_time;
    wire early;
    wire late;
    wire now;
    wire too_early;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .time_now(time_now),
        .trigger_time(trigger_time),
        .early(early),
        .late(late),
        .now(now),
        .too_early(too_early)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Equality at Zero", test_num);
            time_now = 64'h0;
            trigger_time = 64'h0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Equality at Max Value", test_num);
            time_now = 64'hFFFFFFFFFFFFFFFF;
            trigger_time = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Current time is Late (Slightly)", test_num);
            time_now = 64'd100000000000000001;
            trigger_time = 64'd100000000000000000;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Current time is Late (Significant)", test_num);
            time_now = 64'hFFFFFFFFFFFFFFFF;
            trigger_time = 64'h0000000000000001;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Current time is Early (Slightly)", test_num);
            time_now = 64'h7FFFFFFFFFFFFFFF;
            trigger_time = 64'h8000000000000000;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Current time is Early (Significant)", test_num);
            time_now = 64'd0;
            trigger_time = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Mid-range Random Comparison", test_num);
            time_now = 64'hA5A5A5A5A5A5A5A5;
            trigger_time = 64'h5A5A5A5A5A5A5A5A;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
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
        input expected_early;
        input expected_late;
        input expected_now;
        input expected_too_early;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_early === (expected_early ^ early ^ expected_early) &&
                expected_late === (expected_late ^ late ^ expected_late) &&
                expected_now === (expected_now ^ now ^ expected_now) &&
                expected_too_early === (expected_too_early ^ too_early ^ expected_too_early)) begin
                $display("PASS");
                $display("  Outputs: early=%b, late=%b, now=%b, too_early=%b",
                         early, late, now, too_early);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: early=%b, late=%b, now=%b, too_early=%b",
                         expected_early, expected_late, expected_now, expected_too_early);
                $display("  Got:      early=%b, late=%b, now=%b, too_early=%b",
                         early, late, now, too_early);
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

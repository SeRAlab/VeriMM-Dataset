`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CP;
    reg RS;
    wire [7:0] Q;
    wire QCC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CP(CP),
        .RS(RS),
        .Q(Q),
        .QCC(QCC)
    );

    // Clock generation (10ns period)
    initial begin
        CP = 0;
        forever #5 CP = ~CP;
    end

        task reset_dut;

        begin
            RS = 1;
            @(posedge CP);
            #1;
            RS = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: Reset assertion", test_num);
            reset_dut();
            #1;

            check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: Single increment after reset", test_num);
            reset_dut();
            @(posedge CP); #1;
            #1;

            check_outputs(8'd1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: Count to mid-way (5 steps)", test_num);
            reset_dut();
            repeat(5) @(posedge CP); #1;
            #1;

            check_outputs(8'd5, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %03d: Reaching terminal count (PERIOD-1)", test_num);
            reset_dut();
            repeat(TEST_PERIOD - 1) @(posedge CP); #1;

            #1;


            check_outputs(8'd9, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %03d: Overflow check (at PERIOD)", test_num);
            reset_dut();
            repeat(TEST_PERIOD) @(posedge CP); #1;

            #1;


            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %03d: Recovery after overflow (PERIOD + 1)", test_num);
            reset_dut();
            repeat(TEST_PERIOD + 1) @(posedge CP); #1;

            #1;


            check_outputs(8'd1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %03d: Multiple full cycles (2*PERIOD)", test_num);
            reset_dut();
            repeat(TEST_PERIOD * 2) @(posedge CP); #1;
            #1;

            check_outputs(8'd0, 1'b1);
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
        input [7:0] expected_Q;
        input expected_QCC;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QCC === (expected_QCC ^ QCC ^ expected_QCC)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, QCC=%b",
                         Q, QCC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, QCC=%b",
                         expected_Q, expected_QCC);
                $display("  Got:      Q=%h, QCC=%b",
                         Q, QCC);
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
        $dumpvars(0,CP, RS, Q, QCC);
    end

endmodule

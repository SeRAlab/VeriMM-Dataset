`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    wire nege;
    wire pose;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .nege(nege),
        .pose(pose)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 0;
            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in = 1;
            @(posedge clk);
            #2;
            $display("Testcase 001: Positive Edge Detection");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in = 1;
            @(posedge clk);
            in = 0;
            @(posedge clk);
            #2;
            $display("Testcase 002: Negative Edge Detection");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in = 0;
            @(posedge clk);
            #2;
            $display("Testcase 003: Steady Low (No Edge)");
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in = 1;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            #2;
            $display("Testcase 004: Steady High (No Edge)");
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Testcase 005: Pulse Duration Check (Return to 0 after pose)");
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
            in = 1; @(posedge clk);
            #2;
            $display("Testcase 006: Back-to-back transitions (Ending on Pose)");
            #1;

            check_outputs(0, 1);
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
        input expected_nege;
        input expected_pose;
        begin
            if (expected_nege === (expected_nege ^ nege ^ expected_nege) &&
                expected_pose === (expected_pose ^ pose ^ expected_pose)) begin
                $display("PASS");
                $display("  Outputs: nege=%b, pose=%b",
                         nege, pose);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nege=%b, pose=%b",
                         expected_nege, expected_pose);
                $display("  Got:      nege=%b, pose=%b",
                         nege, pose);
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
        $dumpvars(0,clk, in, nege, pose);
    end

endmodule

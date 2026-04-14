`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    wire [3:0] AN1;
    wire [7:0] DISP1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .AN1(AN1),
        .DISP1(DISP1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            $display("Synchronizing for testcase...");

            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase 001: Checking Digit 0 (Initial State)");
            reset_dut();

            #100;
            #1;

            check_outputs(4'b1110, SEG_0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase 002: Checking Digit 1 (after N cycles)");
            reset_dut();

            #(TRANSITION_DELAY - 110);
            #100;
            #1;

            check_outputs(4'b1101, SEG_1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase 003: Checking Digit 2 (after 2*N cycles)");
            reset_dut();
            #(TRANSITION_DELAY);
            #1;

            check_outputs(4'b1011, SEG_2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase 004: Checking Digit 3 (after 3*N cycles)");
            reset_dut();
            #(TRANSITION_DELAY);
            #1;

            check_outputs(4'b0111, SEG_3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase 005: Checking Wrap-around (after 4*N cycles)");
            reset_dut();
            #(TRANSITION_DELAY);
            #1;

            check_outputs(4'b1110, SEG_0);
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
        input [3:0] expected_AN1;
        input [7:0] expected_DISP1;
        begin
            if (expected_AN1 === (expected_AN1 ^ AN1 ^ expected_AN1) &&
                expected_DISP1 === (expected_DISP1 ^ DISP1 ^ expected_DISP1)) begin
                $display("PASS");
                $display("  Outputs: AN1=%h, DISP1=%h",
                         AN1, DISP1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AN1=%h, DISP1=%h",
                         expected_AN1, expected_DISP1);
                $display("  Got:      AN1=%h, DISP1=%h",
                         AN1, DISP1);
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
        $dumpvars(0,CLK, AN1, DISP1);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] KEY;
    reg [9:0] SW;
    wire [7:0] LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .KEY(KEY),
        .SW(SW),
        .LEDR(LEDR)
    );

        task reset_dut;

        begin
            KEY[0] = 0;
            KEY[1] = 0;
            KEY[2] = 0;
            SW = 10'b0;
            #20;
            KEY[1] = 1;
            #10;
        end
        endtask
    task pulse_clk;

        begin
            #10 KEY[0] = 1;
            #10 KEY[0] = 0;
            #10;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load Data (8'hA5)");
            reset_dut();
            SW[7:0] = 8'hA5;
            KEY[2] = 1;
            pulse_clk();
            KEY[2] = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Rotate Left with Wrap");
            reset_dut();

            SW[7:0] = 8'h81;
            KEY[2] = 1;
            pulse_clk();

            KEY[2] = 0;
            SW[8] = 0;
            SW[9] = 1;
            pulse_clk();
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Rotate Right with Wrap");
            reset_dut();

            SW[7:0] = 8'h01;
            KEY[2] = 1;
            pulse_clk();

            KEY[2] = 0;
            SW[8] = 1;
            SW[9] = 1;
            pulse_clk();
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift Left (No Wrap)");
            reset_dut();

            SW[7:0] = 8'h81;
            KEY[2] = 1;
            pulse_clk();

            KEY[2] = 0;
            SW[8] = 0;
            SW[9] = 0;
            pulse_clk();
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift Right (No Wrap)");
            reset_dut();

            SW[7:0] = 8'h81;
            KEY[2] = 1;
            pulse_clk();

            KEY[2] = 0;
            SW[8] = 1;
            SW[9] = 0;
            pulse_clk();
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiple Rotations (Right x2)");
            reset_dut();

            SW[7:0] = 8'h03;
            KEY[2] = 1;
            pulse_clk();

            KEY[2] = 0;
            SW[8] = 1;
            SW[9] = 1;
            pulse_clk();
            pulse_clk();
            #1;

            check_outputs(8'hC0);
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
        input [7:0] expected_LEDR;
        begin
            if (expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: LEDR=%h",
                         LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDR=%h",
                         expected_LEDR);
                $display("  Got:      LEDR=%h",
                         LEDR);
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
        $dumpvars(0,KEY, SW, LEDR);
    end

endmodule

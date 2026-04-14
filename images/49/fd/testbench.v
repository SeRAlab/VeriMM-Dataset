`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] S;
    reg clk;
    reg [3:0] in;
    reg reset;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S(S),
        .clk(clk),
        .in(in),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            S = 2'b00;
            in = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task wait_clk;

        begin
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Parallel Load 4'b1010");
            reset_dut();
            S = 2'b11;
            in = 4'b1010;
            wait_clk();
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load 4'b1111 and Hold");
            reset_dut();

            S = 2'b11; in = 4'b1111;
            wait_clk();

            S = 2'b00; in = 4'b0000;
            wait_clk();
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Right Shift (1000 -> 0100)");
            reset_dut();

            S = 2'b11; in = 4'b1000;
            wait_clk();

            S = 2'b01;
            wait_clk();
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Left Shift (0001 -> 0010)");
            reset_dut();

            S = 2'b11; in = 4'b0001;
            wait_clk();

            S = 2'b10;
            wait_clk();
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple Right Shifts");
            reset_dut();
            S = 2'b11; in = 4'b1100;
            wait_clk();
            S = 2'b01;
            wait_clk();
            wait_clk();
            wait_clk();
            wait_clk();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multiple Left Shifts");
            reset_dut();
            S = 2'b11; in = 4'b0011;
            wait_clk();
            S = 2'b10;
            wait_clk();
            wait_clk();
            wait_clk();
            wait_clk();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Left then Right Shift");
            reset_dut();
            S = 2'b11; in = 4'b0110;
            wait_clk();
            S = 2'b10;
            wait_clk();
            S = 2'b01;
            wait_clk();
            #1;

            check_outputs(4'b0110);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,S, clk, in, reset, Q);
    end

endmodule

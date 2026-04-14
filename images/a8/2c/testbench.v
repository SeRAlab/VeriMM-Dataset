`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] DIN;
    reg DOWN;
    reg LOAD;
    reg UP;
    reg clk;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIN(DIN),
        .DOWN(DOWN),
        .LOAD(LOAD),
        .UP(UP),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            UP = 0;
            DOWN = 0;
            LOAD = 1;
            DIN = 4'b0000;
            @(posedge clk);
            #1;
            LOAD = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Loading value 4'hA...");
            LOAD = 1;
            DIN = 4'hA;
            @(posedge clk);
            #1 LOAD = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Incrementing from 0 to 1...");
            UP = 1;
            @(posedge clk);
            #1 UP = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Decrementing from 0 to 15 (Wraparound)...");
            DOWN = 1;
            @(posedge clk);
            #1 DOWN = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            LOAD = 1;
            DIN = 4'd15;
            @(posedge clk);
            #1 LOAD = 0;
            repeat(5) @(posedge clk);

            $display("Test Case 004: Incrementing from 15 to 0 (Wraparound)...");
            UP = 1;
            @(posedge clk);
            #1 UP = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Incrementing 5 times (0 to 5)...");
            UP = 1;
            repeat(5) @(posedge clk);
            #1 UP = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            LOAD = 1;
            DIN = 4'd10;
            @(posedge clk);
            #1 LOAD = 0;
            repeat(5) @(posedge clk);

            $display("Test Case 006: Decrementing 4 times (10 to 6)...");
            DOWN = 1;
            repeat(4) @(posedge clk);
            #1 DOWN = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            LOAD = 1;
            DIN = 4'd2;
            @(posedge clk);
            #1 LOAD = 0;
            repeat(5) @(posedge clk);

            $display("Test Case 007: Decrementing 4 times from 2 (Wraparound to 14)...");
            DOWN = 1;
            repeat(4) @(posedge clk);
            #1 DOWN = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd14);
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
        $dumpvars(0,DIN, DOWN, LOAD, UP, clk, Q);
    end

endmodule

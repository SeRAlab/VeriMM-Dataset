`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg canLeft;
    reg canRight;
    reg clk;
    reg enable;
    reg reset;
    wire [2:0] Motion;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .canLeft(canLeft),
        .canRight(canRight),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .Motion(Motion)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            canLeft = 0;
            canRight = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Power-on Reset");
            #1;

            check_outputs(NO_MOTION);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            enable = 1;
            canRight = 1;
            @(posedge clk);
            #2;
            $display("Test Case 002: Start Movement (Enable + canRight)");
            #1;

            check_outputs(RIGHT);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enable = 1;
            canRight = 1;
            @(posedge clk);
            canRight = 0;
            @(posedge clk);
            #2;
            $display("Test Case 003: Transition RIGHT -> DOWN");
            #1;

            check_outputs(DOWN);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            enable = 1;
            canRight = 1;
            canLeft = 1;
            @(posedge clk);
            canRight = 0;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test Case 004: Transition DOWN -> LEFT");
            #1;

            check_outputs(LEFT);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enable = 1;
            canRight = 1;
            canLeft = 1;
            @(posedge clk);
            canRight = 0;
            @(posedge clk);
            @(posedge clk);
            canLeft = 0;
            @(posedge clk);
            #2;
            $display("Test Case 005: Transition LEFT -> DOWN");
            #1;

            check_outputs(DOWN);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            enable = 1;
            canRight = 1;
            canLeft = 1;
            @(posedge clk);
            canRight = 0;
            @(posedge clk);
            @(posedge clk);
            canLeft = 0;
            @(posedge clk);
            @(posedge clk);
            #2;
            $display("Test Case 006: Transition DOWN -> RIGHT (Complete Cycle)");
            #1;

            check_outputs(RIGHT);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            enable = 1;
            canRight = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #2;
            $display("Test Case 007: Check Enable Low (Stop Movement)");


            #1;



            check_outputs(NO_MOTION);
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
        input [2:0] expected_Motion;
        begin
            if (expected_Motion === (expected_Motion ^ Motion ^ expected_Motion)) begin
                $display("PASS");
                $display("  Outputs: Motion=%h",
                         Motion);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Motion=%h",
                         expected_Motion);
                $display("  Got:      Motion=%h",
                         Motion);
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
        $dumpvars(0,canLeft, canRight, clk, enable, reset, Motion);
    end

endmodule

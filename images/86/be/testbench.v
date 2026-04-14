`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button;
    reg clk;
    wire bounce_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .clk(clk),
        .bounce_state(bounce_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            button = 0;

            repeat(20) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Constant 0 input");
            reset_dut();
            button = 0;
            repeat(100) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Constant 1 input (L to H transition)");
            reset_dut();
            button = 1;


            repeat(500) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: High-level glitch rejection");
            reset_dut();
            button = 0;
            repeat(10) @(posedge clk);


            button = 1;
            repeat(5) @(posedge clk);
            button = 0;


            repeat(100) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Low-level glitch rejection while stable high");
            reset_dut();


            button = 1;
            repeat(500) @(posedge clk);


            button = 0;
            repeat(5) @(posedge clk);
            button = 1;


            repeat(100) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Stable low after release");
            reset_dut();


            button = 1;
            repeat(500) @(posedge clk);


            button = 0;

            repeat(500) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Simulating mechanical bouncing");
            reset_dut();


            button = 1; #20;
            button = 0; #30;
            button = 1; #40;
            button = 0; #20;
            button = 1;


            repeat(500) @(posedge clk);
            #1;

            check_outputs(1'b1);
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
        input expected_bounce_state;
        begin
            if (expected_bounce_state === (expected_bounce_state ^ bounce_state ^ expected_bounce_state)) begin
                $display("PASS");
                $display("  Outputs: bounce_state=%b",
                         bounce_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bounce_state=%b",
                         expected_bounce_state);
                $display("  Got:      bounce_state=%b",
                         bounce_state);
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
        $dumpvars(0,button, clk, bounce_state);
    end

endmodule

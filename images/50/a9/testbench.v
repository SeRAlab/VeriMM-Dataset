`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button_in;
    reg clk;
    wire debounce_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button_in(button_in),
        .clk(clk),
        .debounce_output(debounce_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            button_in = 0;

            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial State Check...");
            reset_dut();
            repeat(50) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Glitch Rejection...");
            reset_dut();


            button_in = 1;
            repeat(5) @(posedge clk);
            button_in = 0;


            repeat(100) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Stable High Input...");
            reset_dut();


            button_in = 1;
            repeat(256) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Stable Low Input...");
            reset_dut();


            button_in = 1;
            repeat(256) @(posedge clk);


            button_in = 0;
            repeat(256) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Bouncing Signal Check...");
            reset_dut();


            button_in = 1; repeat(5) @(posedge clk);
            button_in = 0; repeat(3) @(posedge clk);
            button_in = 1; repeat(8) @(posedge clk);
            button_in = 0; repeat(4) @(posedge clk);


            button_in = 1;
            repeat(256) @(posedge clk);

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
        input expected_debounce_output;
        begin
            if (expected_debounce_output === (expected_debounce_output ^ debounce_output ^ expected_debounce_output)) begin
                $display("PASS");
                $display("  Outputs: debounce_output=%b",
                         debounce_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: debounce_output=%b",
                         expected_debounce_output);
                $display("  Got:      debounce_output=%b",
                         debounce_output);
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
        $dumpvars(0,button_in, clk, debounce_output);
    end

endmodule

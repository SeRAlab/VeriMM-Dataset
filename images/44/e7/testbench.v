`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bouncy;
    reg clk;
    wire debounced;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bouncy(bouncy),
        .clk(clk),
        .debounced(debounced)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bouncy = 0;
            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            bouncy = 0;
            repeat (5) @(posedge clk);
            #1;
            $display("Test Case 001: Constant Low Input");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge clk);
            #1 bouncy = 1;
            repeat (3) @(posedge clk);
            #1;
            $display("Test Case 002: Constant High Input (3 Cycles)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge clk);
            #1 bouncy = 1;
            repeat (2) @(posedge clk);
            #1 bouncy = 0;
            repeat (2) @(posedge clk);
            #1;
            $display("Test Case 003: Short Glitch High (2 Cycles)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge clk);
            #1 bouncy = 1;
            repeat (4) @(posedge clk);


            #1 bouncy = 0;
            repeat (3) @(posedge clk);
            #1;
            $display("Test Case 004: Transition to Low (3 Cycles)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge clk); #1 bouncy = 1;
            @(posedge clk); #1 bouncy = 0;
            @(posedge clk); #1 bouncy = 1;
            @(posedge clk); #1 bouncy = 0;

            @(posedge clk); #1 bouncy = 1;
            repeat (4) @(posedge clk);
            #1;
            $display("Test Case 005: Bouncy Input then Stabilization");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge clk); #1 bouncy = 1;
            repeat (4) @(posedge clk);



            #1 bouncy = 0;
            @(posedge clk);
            #1 bouncy = 1;
            repeat (2) @(posedge clk);
            #1;
            $display("Test Case 006: High with 1-cycle Low Glitch (Total High 2 cycles after glitch)");



            #1;




            check_outputs(1'b0);
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
        input expected_debounced;
        begin
            if (expected_debounced === (expected_debounced ^ debounced ^ expected_debounced)) begin
                $display("PASS");
                $display("  Outputs: debounced=%b",
                         debounced);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: debounced=%b",
                         expected_debounced);
                $display("  Got:      debounced=%b",
                         debounced);
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
        $dumpvars(0,bouncy, clk, debounced);
    end

endmodule

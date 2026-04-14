`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] count_to;
    reg [31:0] frequency;
    reg reset;
    wire [31:0] count;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count_to(count_to),
        .frequency(frequency),
        .reset(reset),
        .count(count),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            repeat (2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Simple count, Freq=1", test_num);
            reset_dut();
            count_to = 10;
            frequency = 1;


            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(10, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Slow frequency, Freq=5, Target=2", test_num);
            reset_dut();
            count_to = 2;
            frequency = 5;


            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(2, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Intermediate check", test_num);
            reset_dut();
            count_to = 10;
            frequency = 2;


            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(5, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Large divisor", test_num);
            reset_dut();
            count_to = 1;
            frequency = 50;

            repeat (50) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Zero count target", test_num);
            reset_dut();
            count_to = 0;
            frequency = 1;



            @(posedge clk);
            #1;
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
        input [31:0] expected_count;
        input expected_done;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: count=%h, done=%b",
                         count, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, done=%b",
                         expected_count, expected_done);
                $display("  Got:      count=%h, done=%b",
                         count, done);
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
        $dumpvars(0,clk, count_to, frequency, reset, count, done);
    end

endmodule

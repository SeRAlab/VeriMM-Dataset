`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire clk_delayed;
    wire reset_delayed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .clk_delayed(clk_delayed),
        .reset_delayed(reset_delayed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            #15;
            @(negedge clk);
            reset = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking outputs immediately after reset...", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking outputs after 1 clock cycle...", test_num);
            reset_dut();
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking outputs after 2 clock cycles (Pipeline should fill)...", test_num);
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checking stability after 10 cycles...", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Verifying asynchronous reset behavior...", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            reset = 0;
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_clk_delayed;
        input expected_reset_delayed;
        begin
            if (expected_clk_delayed === (expected_clk_delayed ^ clk_delayed ^ expected_clk_delayed) &&
                expected_reset_delayed === (expected_reset_delayed ^ reset_delayed ^ expected_reset_delayed)) begin
                $display("PASS");
                $display("  Outputs: clk_delayed=%b, reset_delayed=%b",
                         clk_delayed, reset_delayed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_delayed=%b, reset_delayed=%b",
                         expected_clk_delayed, expected_reset_delayed);
                $display("  Got:      clk_delayed=%b, reset_delayed=%b",
                         clk_delayed, reset_delayed);
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
        $dumpvars(0,clk, reset, clk_delayed, reset_delayed);
    end

endmodule

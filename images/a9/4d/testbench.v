`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] count;
    wire max;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .count(count),
        .max(max)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            @(posedge clk);
            #1;
            reset = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Increment", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Increment to 7", test_num);
            reset_dut();
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h7, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Reach Maximum Value (15)", test_num);
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Counter Wrap-around (15 to 0)", test_num);
            reset_dut();
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Wrap-around then increment to 3", test_num);
            reset_dut();
            repeat(19) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h3, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Multiple Wrap-arounds (Reach 15 again)", test_num);
            reset_dut();
            repeat(31) @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Asynchronous-like Reset from 15", test_num);
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            reset = 0;
            #5;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1'b0);
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
        testcase008();
        
        
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
        input [3:0] expected_count;
        input expected_max;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_max === (expected_max ^ max ^ expected_max)) begin
                $display("PASS");
                $display("  Outputs: count=%h, max=%b",
                         count, max);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, max=%b",
                         expected_count, expected_max);
                $display("  Got:      count=%h, max=%b",
                         count, max);
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
        $dumpvars(0,clk, reset, count, max);
    end

endmodule

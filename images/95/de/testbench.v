`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count)
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
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Normal Counting to 5", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Boundary Count to 9", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Wrap-around logic (10 pulses)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Count after wrap-around (12 pulses)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(12) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Enable/Pause functionality", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(3) @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Enable logic at boundary 9", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(9) @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %03d: Asynchronous reset during operation", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(4) @(posedge clk);
            #3;
            reset = 1;
            #1;
            #1;

            check_outputs(4'd0);
            reset = 0;
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
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, enable, reset, count);
    end

endmodule

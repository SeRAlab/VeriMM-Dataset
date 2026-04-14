`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_sw;
    wire o_sw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_sw(i_sw),
        .o_sw(o_sw)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            i_sw = 0;

            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            i_sw = 0;
            repeat (5) @(posedge clk);
            $display("Test Case 001: Stable Low Input");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            i_sw = 1;

            repeat (4) @(posedge clk);
            $display("Test Case 002: Transition to Stable High");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            i_sw = 1;
            repeat (4) @(posedge clk);

            i_sw = 0;
            repeat (4) @(posedge clk);
            $display("Test Case 003: Transition back to Stable Low");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            i_sw = 1; #7;
            i_sw = 0; #4;
            i_sw = 1; #12;
            i_sw = 0; #3;


            i_sw = 1;
            repeat (5) @(posedge clk);

            $display("Test Case 004: Bouncy Input followed by Stability");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            #2;
            i_sw = 1;
            repeat (5) @(posedge clk);
            $display("Test Case 005: Asynchronous High Signal");
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
        input expected_o_sw;
        begin
            if (expected_o_sw === (expected_o_sw ^ o_sw ^ expected_o_sw)) begin
                $display("PASS");
                $display("  Outputs: o_sw=%b",
                         o_sw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_sw=%b",
                         expected_o_sw);
                $display("  Got:      o_sw=%b",
                         o_sw);
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
        $dumpvars(0,clk, i_sw, o_sw);
    end

endmodule

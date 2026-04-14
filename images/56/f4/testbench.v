`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [11:0] temp_input;
    wire [15:0] temp_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .temp_input(temp_input),
        .temp_output(temp_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temp_input = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Reset logic", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: 0 degrees Celsius", test_num);
            reset_dut();
            temp_input = 12'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd32);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: 100 degrees Celsius", test_num);
            reset_dut();
            temp_input = 12'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd212);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: 25 degrees Celsius", test_num);
            reset_dut();
            temp_input = 12'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd77);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: 1000 degrees Celsius", test_num);
            reset_dut();
            temp_input = 12'd1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1832);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: 4095 degrees Celsius (MAX)", test_num);
            reset_dut();
            temp_input = 12'hFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd7403);
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
        input [15:0] expected_temp_output;
        begin
            if (expected_temp_output === (expected_temp_output ^ temp_output ^ expected_temp_output)) begin
                $display("PASS");
                $display("  Outputs: temp_output=%h",
                         temp_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_output=%h",
                         expected_temp_output);
                $display("  Got:      temp_output=%h",
                         temp_output);
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
        $dumpvars(0,clk, reset, temp_input, temp_output);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_signal;
    reg reset;
    wire [7:0] motor_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_signal(input_signal),
        .reset(reset),
        .motor_speed(motor_speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_signal = 0;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            input_signal = 16'd0;
            @(posedge clk);
            #1;
            $display("Test Case 001: Zero Input");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            input_signal = 16'd32767;
            @(posedge clk);
            #1;
            $display("Test Case 002: Boundary Input 32767 (0x7FFF)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            input_signal = 16'd32768;
            @(posedge clk);
            #1;
            $display("Test Case 003: Boundary Input 32768 (0x8000)");
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            input_signal = 16'hFFFF;
            @(posedge clk);
            #1;
            $display("Test Case 004: Maximum Input 65535 (0xFFFF)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            input_signal = 16'd12800;
            @(posedge clk);
            #1;
            $display("Test Case 005: Typical Low Range Input 12800");
            #1;

            check_outputs(8'h64);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            input_signal = 16'd51200;
            @(posedge clk);
            #1;
            $display("Test Case 006: Typical High Range Input 51200");
            #1;

            check_outputs(8'hC8);
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
        input [7:0] expected_motor_speed;
        begin
            if (expected_motor_speed === (expected_motor_speed ^ motor_speed ^ expected_motor_speed)) begin
                $display("PASS");
                $display("  Outputs: motor_speed=%h",
                         motor_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: motor_speed=%h",
                         expected_motor_speed);
                $display("  Got:      motor_speed=%h",
                         motor_speed);
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
        $dumpvars(0,clk, input_signal, reset, motor_speed);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg new_bit;
    reg [1:0] select;
    reg [7:0] signal_input;
    wire serial_output;
    wire [7:0] signal_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .new_bit(new_bit),
        .select(select),
        .signal_input(signal_input),
        .serial_output(serial_output),
        .signal_output(signal_output)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            select = 2'b01;
            signal_input = 8'h00;
            new_bit = 0;
            @(negedge CLK);
            select = 2'b00;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %03d: Parallel Load 8'hA5", test_num);
            @(negedge CLK);
            select = 2'b01;
            signal_input = 8'hA5;
            @(negedge CLK);
            select = 2'b00;
            #1;

            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %03d: Hold Mode (select=00)", test_num);
            @(negedge CLK);
            select = 2'b01;
            signal_input = 8'h5A;
            @(negedge CLK);
            select = 2'b00;
            repeat(3) @(negedge CLK);
            #1;

            check_outputs(1'b0, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %03d: Left Shift (8'h80 -> 8'h00, serial out 1)", test_num);
            @(negedge CLK);
            select = 2'b01;
            signal_input = 8'h80;
            @(negedge CLK);
            select = 2'b10;
            new_bit = 0;
            @(negedge CLK);
            select = 2'b00;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %03d: Right Shift (8'h01 -> 8'h00, serial out 1)", test_num);
            @(negedge CLK);
            select = 2'b01;
            signal_input = 8'h01;
            @(negedge CLK);
            select = 2'b11;
            new_bit = 0;
            @(negedge CLK);
            select = 2'b00;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %03d: Left Shift Fill (4 bits)", test_num);
            @(negedge CLK);
            select = 2'b10;
            new_bit = 1;
            repeat(4) @(negedge CLK);
            select = 2'b00;
            #1;

            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %03d: Right Shift Fill (4 bits)", test_num);
            @(negedge CLK);
            select = 2'b11;
            new_bit = 1;
            repeat(4) @(negedge CLK);
            select = 2'b00;
            #1;

            check_outputs(1'b0, 8'hF0);
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
        input expected_serial_output;
        input [7:0] expected_signal_output;
        begin
            if (expected_serial_output === (expected_serial_output ^ serial_output ^ expected_serial_output) &&
                expected_signal_output === (expected_signal_output ^ signal_output ^ expected_signal_output)) begin
                $display("PASS");
                $display("  Outputs: serial_output=%b, signal_output=%h",
                         serial_output, signal_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_output=%b, signal_output=%h",
                         expected_serial_output, expected_signal_output);
                $display("  Got:      serial_output=%b, signal_output=%h",
                         serial_output, signal_output);
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
        $dumpvars(0,CLK, new_bit, select, signal_input, serial_output, signal_output);
    end

endmodule

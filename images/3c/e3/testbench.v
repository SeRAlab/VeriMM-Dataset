`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control_signal;
    reg reset;
    wire [1:0] frequency_level;
    wire [1:0] voltage_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .control_signal(control_signal),
        .reset(reset),
        .frequency_level(frequency_level),
        .voltage_level(voltage_level)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control_signal = 2'b11;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Control Signal 00 (1GHz, 0V)");
            reset_dut();
            control_signal = 2'b00;
            @(posedge clk);
            #2;
            test_num = 1;
            #1;

            check_outputs(2'd1, 2'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Control Signal 01 (2GHz, 1V)");
            reset_dut();
            control_signal = 2'b01;
            @(posedge clk);
            #2;
            test_num = 2;
            #1;

            check_outputs(2'd2, 2'd1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Control Signal 10 (3GHz, 2V)");
            reset_dut();
            control_signal = 2'b10;
            @(posedge clk);
            #2;
            test_num = 3;
            #1;

            check_outputs(2'd3, 2'd2);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Control Signal 11 (1GHz, 0V)");
            reset_dut();
            control_signal = 2'b11;
            @(posedge clk);
            #2;
            test_num = 4;
            #1;

            check_outputs(2'd1, 2'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [1:0] expected_frequency_level;
        input [1:0] expected_voltage_level;
        begin
            if (expected_frequency_level === (expected_frequency_level ^ frequency_level ^ expected_frequency_level) &&
                expected_voltage_level === (expected_voltage_level ^ voltage_level ^ expected_voltage_level)) begin
                $display("PASS");
                $display("  Outputs: frequency_level=%h, voltage_level=%h",
                         frequency_level, voltage_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_level=%h, voltage_level=%h",
                         expected_frequency_level, expected_voltage_level);
                $display("  Got:      frequency_level=%h, voltage_level=%h",
                         frequency_level, voltage_level);
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
        $dumpvars(0,clk, control_signal, reset, frequency_level, voltage_level);
    end

endmodule

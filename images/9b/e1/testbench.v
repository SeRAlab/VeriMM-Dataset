`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i2c_scl;
    reg reset;
    wire [15:0] temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i2c_scl(i2c_scl),
        .reset(reset),
        .temperature(temperature)
    );

    // Clock generation (10ns period)
    initial begin
        i2c_scl = 0;
        forever #5 i2c_scl = ~i2c_scl;
    end

        task reset_dut;

        begin
            reset = 1;
            sda_drive = 0;
            sda_val = 0;
            repeat(5) @(posedge i2c_scl);
            reset = 0;
            repeat(2) @(posedge i2c_scl);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Positive Temperature 25C", test_num);
            reset_dut();
            i2c_slave_respond(16'h0C80);
            #1;

            check_outputs(16'sd25);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Negative Temperature -10C", test_num);
            reset_dut();
            i2c_slave_respond(16'hFB00);
            #1;

            check_outputs(16'sd-10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Zero Temperature 0C", test_num);
            reset_dut();
            i2c_slave_respond(16'h0000);
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: High Temperature 125C", test_num);
            reset_dut();
            i2c_slave_respond(16'h3E80);
            #1;

            check_outputs(16'sd125);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Cold Temperature -40C", test_num);
            reset_dut();
            i2c_slave_respond(16'hEC00);
            #1;

            check_outputs(16'sd-40);
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
        input [15:0] expected_temperature;
        begin
            if (expected_temperature === (expected_temperature ^ temperature ^ expected_temperature)) begin
                $display("PASS");
                $display("  Outputs: temperature=%h",
                         temperature);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temperature=%h",
                         expected_temperature);
                $display("  Got:      temperature=%h",
                         temperature);
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
        $dumpvars(0,i2c_scl, reset, temperature);
    end

endmodule

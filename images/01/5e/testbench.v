`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    wire [7:0] frequency;
    wire [7:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .frequency(frequency),
        .voltage(voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temperature = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Temp = 15 (Cold)");
            reset_dut();
            temperature = 8'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10, 8'd10);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Temp = 25 (Lower Boundary)");
            reset_dut();
            temperature = 8'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd8, 8'd8);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Temp = 45 (Normal)");
            reset_dut();
            temperature = 8'd45;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd8, 8'd8);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Temp = 70 (Upper Boundary)");
            reset_dut();
            temperature = 8'd70;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd8, 8'd8);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Temp = 71 (Transition to Hot)");
            reset_dut();
            temperature = 8'd71;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd6, 8'd6);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Temp = 100 (High)");
            reset_dut();
            temperature = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd6, 8'd6);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Reset while hot");
            reset_dut();
            temperature = 8'd85;
            @(posedge clk);
            #1;

            if (frequency == 8'd6 && voltage == 8'd6) begin

                reset = 1;
                @(posedge clk);
                #1;


                #1;



                check_outputs(8'd10, 8'd10);
            end else begin
                $display("FAIL: Initial setup for testcase007 failed");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DVFS_Controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_frequency;
        input [7:0] expected_voltage;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency) &&
                expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h, voltage=%h",
                         frequency, voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h, voltage=%h",
                         expected_frequency, expected_voltage);
                $display("  Got:      frequency=%h, voltage=%h",
                         frequency, voltage);
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
        $dumpvars(0,clk, reset, temperature, frequency, voltage);
    end

endmodule

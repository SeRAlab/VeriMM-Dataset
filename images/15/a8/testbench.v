`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] calibration_factor;
    reg clk;
    reg rst;
    reg [9:0] temp_input;
    wire [9:0] temp_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .rst(rst),
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
        rst = 1;
        temp_input = 0;
        calibration_factor = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        temp_input = 10'd0;
        calibration_factor = 4'd0;
        @(posedge clk);
        #2;
        $display("Testcase 001: Zero Input / No Calibration");
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        temp_input = 10'd100;
        calibration_factor = 4'd5;
        @(posedge clk);
        #2;
        $display("Testcase 002: Normal Operation (100 + 5)");
        #1;

        check_outputs(10'd105);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        temp_input = 10'd500;
        calibration_factor = 4'd15;
        @(posedge clk);
        #2;
        $display("Testcase 003: Max Calibration Factor (500 + 15)");
        #1;

        check_outputs(10'd515);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        temp_input = 10'd1000;
        calibration_factor = 4'd10;
        @(posedge clk);
        #2;
        $display("Testcase 004: High Input Range (1000 + 10)");
        #1;

        check_outputs(10'd1010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        temp_input = 10'd1023;
        calibration_factor = 4'd2;
        @(posedge clk);
        #2;
        $display("Testcase 005: Overflow Wrap-around (1023 + 2)");
        #1;

        check_outputs(10'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        temp_input = 10'd512;
        calibration_factor = 4'd0;
        @(posedge clk);
        #2;
        $display("Testcase 006: Mid-scale input, zero factor");
        #1;

        check_outputs(10'd512);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("thermal_sensor_calibration Testbench");
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
        input [9:0] expected_temp_output;
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
        $dumpvars(0,calibration_factor, clk, rst, temp_input, temp_output);
    end

endmodule

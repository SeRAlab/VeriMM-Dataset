`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] calibration_factor;
    reg clk;
    reg [11:0] raw_temp;
    reg rst;
    wire [11:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .raw_temp(raw_temp),
        .rst(rst),
        .calibrated_temp(calibrated_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            raw_temp = 12'h0;
            calibration_factor = 12'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic calibration offset...");
            reset_dut();
            raw_temp = 12'h200;
            calibration_factor = 12'h010;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(12'h210);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Zero calibration factor...");
            reset_dut();
            raw_temp = 12'hA00;
            calibration_factor = 12'h000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(12'hA00);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: High range values...");
            reset_dut();
            raw_temp = 12'hF00;
            calibration_factor = 12'h00F;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(12'hF0F);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Reset initialization check...");

            reset_dut();
            raw_temp = 12'h500;
            calibration_factor = 12'h050;
            repeat(2) @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h000);
            rst = 0;
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Output persistence between cycles...");
            reset_dut();
            raw_temp = 12'h123;
            calibration_factor = 12'h001;
            repeat(2) @(posedge clk);


            raw_temp = 12'hFFF;

            #1;


            check_outputs(12'h124);
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
        input [11:0] expected_calibrated_temp;
        begin
            if (expected_calibrated_temp === (expected_calibrated_temp ^ calibrated_temp ^ expected_calibrated_temp)) begin
                $display("PASS");
                $display("  Outputs: calibrated_temp=%h",
                         calibrated_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_temp=%h",
                         expected_calibrated_temp);
                $display("  Got:      calibrated_temp=%h",
                         calibrated_temp);
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
        $dumpvars(0,calibration_factor, clk, raw_temp, rst, calibrated_temp);
    end

endmodule

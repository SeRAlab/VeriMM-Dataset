`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] calibration_factor;
    reg clk;
    reg enable_calibration;
    reg [11:0] raw_temp;
    wire [11:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .enable_calibration(enable_calibration),
        .raw_temp(raw_temp),
        .calibrated_temp(calibrated_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        calibration_factor = 0;
        enable_calibration = 0;
        raw_temp = 0;

        repeat (2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Calibration (Raw=100, Factor=50, Enabled)");
        reset_dut();
        test_num = test_num + 1;

        raw_temp = 12'd100;
        calibration_factor = 12'd50;
        enable_calibration = 1'b1;


        @(posedge clk);
        #2;

        #1;


        check_outputs(12'd150);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Calibration Disabled (Raw=200, Factor=50, Disabled)");
        reset_dut();
        test_num = test_num + 1;

        raw_temp = 12'd200;
        calibration_factor = 12'd50;
        enable_calibration = 1'b0;

        @(posedge clk);
        #2;


        #1;



        check_outputs(12'd200);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Maximum value calibration (Overflow check)");
        reset_dut();
        test_num = test_num + 1;

        raw_temp = 12'hFFF;
        calibration_factor = 12'h001;
        enable_calibration = 1'b1;

        @(posedge clk);
        #2;


        #1;



        check_outputs(12'h000);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Zero Calibration Factor");
        reset_dut();
        test_num = test_num + 1;

        raw_temp = 12'hABC;
        calibration_factor = 12'h000;
        enable_calibration = 1'b1;

        @(posedge clk);
        #2;

        #1;


        check_outputs(12'hABC);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Sequential Holding Check (Changing input between edges)");
        reset_dut();
        test_num = test_num + 1;


        raw_temp = 12'd500;
        calibration_factor = 12'd100;
        enable_calibration = 1'b1;
        @(posedge clk);
        #2;


        raw_temp = 12'd800;
        calibration_factor = 12'd200;
        #2;



        #1;




        check_outputs(12'd600);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Sequential Update Check");
        reset_dut();
        test_num = test_num + 1;

        raw_temp = 12'd800;
        calibration_factor = 12'd200;
        enable_calibration = 1'b1;


        @(posedge clk);
        #2;

        #1;


        check_outputs(12'd1000);
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
        $dumpvars(0,calibration_factor, clk, enable_calibration, raw_temp, calibrated_temp);
    end

endmodule

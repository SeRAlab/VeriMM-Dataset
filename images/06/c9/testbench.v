`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] calibration_value;
    reg clk;
    reg [11:0] raw_data;
    reg rst;
    wire [11:0] calibrated_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_value(calibration_value),
        .clk(clk),
        .raw_data(raw_data),
        .rst(rst),
        .calibrated_data(calibrated_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            raw_data = 0;
            calibration_value = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Basic calibration (500 + 100)", test_num);
            raw_data = 12'd500;
            calibration_value = 12'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'd600);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Zero calibration offset", test_num);
            raw_data = 12'hABC;
            calibration_value = 12'h000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Max raw data (4095 + 1)", test_num);
            raw_data = 12'hFFF;
            calibration_value = 12'h001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Large offset wrap-around", test_num);
            raw_data = 12'h800;
            calibration_value = 12'h800;
            @(posedge clk);
            #2;

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: All bits high (FFFF + FFFF)", test_num);
            raw_data = 12'hFFF;
            calibration_value = 12'hFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(12'hFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Reset behavior (Output should be 0 after reset)", test_num);


            #1;



            check_outputs(12'h000);
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
        input [11:0] expected_calibrated_data;
        begin
            if (expected_calibrated_data === (expected_calibrated_data ^ calibrated_data ^ expected_calibrated_data)) begin
                $display("PASS");
                $display("  Outputs: calibrated_data=%h",
                         calibrated_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_data=%h",
                         expected_calibrated_data);
                $display("  Got:      calibrated_data=%h",
                         calibrated_data);
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
        $dumpvars(0,calibration_value, clk, raw_data, rst, calibrated_data);
    end

endmodule

`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature_in;
    wire [7:0] calibrated_temperature;
    wire needs_calibration;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .clk(clk),
        .reset(reset),
        .temperature_in(temperature_in),
        .calibrated_temperature(calibrated_temperature),
        .needs_calibration(needs_calibration)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temperature_in = 8'd0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Minimum Temperature", test_num);
            reset_dut();
            temperature_in = 8'd0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal Temperature", test_num);
            reset_dut();
            temperature_in = 8'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd25, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Mid-range Temperature (Below Threshold)", test_num);
            reset_dut();
            temperature_in = 8'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd150, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Boundary Temperature", test_num);
            reset_dut();
            temperature_in = 8'd199;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd199, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High Temperature (Triggers Recalibration)", test_num);
            reset_dut();
            temperature_in = 8'd210;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd210, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Maximum Temperature", test_num);
            reset_dut();
            temperature_in = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
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
        input [7:0] expected_calibrated_temperature;
        input expected_needs_calibration;
        begin
            if (expected_calibrated_temperature === (expected_calibrated_temperature ^ calibrated_temperature ^ expected_calibrated_temperature) &&
                expected_needs_calibration === (expected_needs_calibration ^ needs_calibration ^ expected_needs_calibration)) begin
                $display("PASS");
                $display("  Outputs: calibrated_temperature=%h, needs_calibration=%b",
                         calibrated_temperature, needs_calibration);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_temperature=%h, needs_calibration=%b",
                         expected_calibrated_temperature, expected_needs_calibration);
                $display("  Got:      calibrated_temperature=%h, needs_calibration=%b",
                         calibrated_temperature, needs_calibration);
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
        $dumpvars(0,clk, reset, temperature_in, calibrated_temperature, needs_calibration);
    end

endmodule

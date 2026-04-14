`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] calibration_value;
    reg clk;
    reg reset;
    reg [9:0] sensor_input;
    wire [9:0] calibrated_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_value(calibration_value),
        .clk(clk),
        .reset(reset),
        .sensor_input(sensor_input),
        .calibrated_output(calibrated_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            sensor_input = 0;
            calibration_value = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset functionality", test_num);
            sensor_input = 10'h1FF;
            calibration_value = 8'hFF;
            reset = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Zero calibration value adjustment", test_num);
            sensor_input = 10'd500;
            calibration_value = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Standard positive calibration", test_num);
            sensor_input = 10'd400;
            calibration_value = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Large input and calibration values", test_num);
            sensor_input = 10'd700;
            calibration_value = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd955);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: 10-bit overflow / wrap-around check", test_num);
            sensor_input = 10'd1023;
            calibration_value = 8'd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Zero sensor input with calibration", test_num);
            sensor_input = 10'd0;
            calibration_value = 8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd128);
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
        input [9:0] expected_calibrated_output;
        begin
            if (expected_calibrated_output === (expected_calibrated_output ^ calibrated_output ^ expected_calibrated_output)) begin
                $display("PASS");
                $display("  Outputs: calibrated_output=%h",
                         calibrated_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_output=%h",
                         expected_calibrated_output);
                $display("  Got:      calibrated_output=%h",
                         calibrated_output);
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
        $dumpvars(0,calibration_value, clk, reset, sensor_input, calibrated_output);
    end

endmodule

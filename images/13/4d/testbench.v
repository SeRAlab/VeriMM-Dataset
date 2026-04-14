`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] calibration_factor;
    reg clk;
    reg reset;
    reg [7:0] sensor_input;
    wire [9:0] calibrated_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
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
            @(posedge clk);
            reset = 1;
            sensor_input = 0;
            calibration_factor = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Post-Reset Initialization", test_num);
            reset_dut();

            #1;


            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sensor Input Zero", test_num);
            reset_dut();
            sensor_input = 8'd0;
            calibration_factor = 5'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Calibration Factor Zero", test_num);
            reset_dut();
            sensor_input = 8'd100;
            calibration_factor = 5'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Standard Calibration (10 * 5)", test_num);
            reset_dut();
            sensor_input = 8'd10;
            calibration_factor = 5'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range Calibration (50 * 15)", test_num);
            reset_dut();
            sensor_input = 8'd50;
            calibration_factor = 5'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd750);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max result within 10 bits (32 * 31)", test_num);
            reset_dut();
            sensor_input = 8'd32;
            calibration_factor = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd992);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Truncation Check (255 * 31)", test_num);
            reset_dut();
            sensor_input = 8'd255;
            calibration_factor = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd737);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dynamic Input Change", test_num);
            reset_dut();


            sensor_input = 8'd20;
            calibration_factor = 5'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd40);


            sensor_input = 8'd15;
            calibration_factor = 5'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd45);
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
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,calibration_factor, clk, reset, sensor_input, calibrated_output);
    end

endmodule

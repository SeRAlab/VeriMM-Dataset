`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load_offset;
    reg [9:0] offset_value;
    reg [9:0] raw_reading;
    reg reset;
    reg start_calibration;
    wire [9:0] calibrated_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .clk(clk),
        .load_offset(load_offset),
        .offset_value(offset_value),
        .raw_reading(raw_reading),
        .reset(reset),
        .start_calibration(start_calibration),
        .calibrated_value(calibrated_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load_offset = 0;
            offset_value = 0;
            raw_reading = 0;
            start_calibration = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            $display("DUT Reset sequence completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic calibration", test_num);
            reset_dut();


            offset_value = 10'd50;
            load_offset = 1;
            @(posedge clk);
            #1 load_offset = 0;


            raw_reading = 10'd200;
            start_calibration = 1;
            @(posedge clk);
            #1 start_calibration = 0;


            @(posedge clk);
            #1;

            check_outputs(10'd250);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero offset calibration", test_num);
            reset_dut();


            offset_value = 10'd0;
            load_offset = 1;
            @(posedge clk);
            #1 load_offset = 0;


            raw_reading = 10'd789;
            start_calibration = 1;
            @(posedge clk);
            #1 start_calibration = 0;


            @(posedge clk);
            #1;

            check_outputs(10'd789);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow handling (Wrap-around)", test_num);
            reset_dut();


            offset_value = 10'd100;
            load_offset = 1;
            @(posedge clk);
            #1 load_offset = 0;


            raw_reading = 10'd950;
            start_calibration = 1;
            @(posedge clk);
            #1 start_calibration = 0;


            @(posedge clk);
            #1;

            check_outputs(10'd26);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum offset value", test_num);
            reset_dut();


            offset_value = 10'h3FF;
            load_offset = 1;
            @(posedge clk);
            #1 load_offset = 0;


            raw_reading = 10'd5;
            start_calibration = 1;
            @(posedge clk);
            #1 start_calibration = 0;


            @(posedge clk);
            #1;

            check_outputs(10'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change offset after first calibration", test_num);
            reset_dut();


            offset_value = 10'd10;
            load_offset = 1;
            @(posedge clk);
            #1 load_offset = 0;
            raw_reading = 10'd100;
            start_calibration = 1;
            @(posedge clk);
            #1 start_calibration = 0;


            offset_value = 10'd20;
            load_offset = 1;
            @(posedge clk);
            #1 load_offset = 0;

            start_calibration = 1;
            @(posedge clk);
            #1 start_calibration = 0;


            @(posedge clk);
            #1;

            check_outputs(10'd120);
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
        input [9:0] expected_calibrated_value;
        begin
            if (expected_calibrated_value === (expected_calibrated_value ^ calibrated_value ^ expected_calibrated_value)) begin
                $display("PASS");
                $display("  Outputs: calibrated_value=%h",
                         calibrated_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_value=%h",
                         expected_calibrated_value);
                $display("  Got:      calibrated_value=%h",
                         calibrated_value);
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
        $dumpvars(0,clk, load_offset, offset_value, raw_reading, reset, start_calibration, calibrated_value);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] sensor_data;
    reg sensor_sel;
    wire sensor_data_ready;
    wire sensor_data_valid;
    wire [15:0] sensor_data_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .sensor_data(sensor_data),
        .sensor_sel(sensor_sel),
        .sensor_data_ready(sensor_data_ready),
        .sensor_data_valid(sensor_data_valid),
        .sensor_data_value(sensor_data_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sensor_sel = 0;
            sensor_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Power-on Reset", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Valid Sensor Selection", test_num);
            reset_dut();

            sensor_sel = 1;
            sensor_data = 16'hABCD;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 1, 16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Inactive Sensor Selection", test_num);
            reset_dut();


            sensor_sel = 1;
            sensor_data = 16'h1234;
            @(posedge clk);


            sensor_sel = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Continuous Data Update", test_num);
            reset_dut();

            sensor_sel = 1;
            sensor_data = 16'hAAAA;
            @(posedge clk);

            sensor_data = 16'h5555;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 1, 16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset Override", test_num);
            reset_dut();

            sensor_sel = 1;
            sensor_data = 16'hFFFF;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 16'h0000);
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
        input expected_sensor_data_ready;
        input expected_sensor_data_valid;
        input [15:0] expected_sensor_data_value;
        begin
            if (expected_sensor_data_ready === (expected_sensor_data_ready ^ sensor_data_ready ^ expected_sensor_data_ready) &&
                expected_sensor_data_valid === (expected_sensor_data_valid ^ sensor_data_valid ^ expected_sensor_data_valid) &&
                expected_sensor_data_value === (expected_sensor_data_value ^ sensor_data_value ^ expected_sensor_data_value)) begin
                $display("PASS");
                $display("  Outputs: sensor_data_ready=%b, sensor_data_valid=%b, sensor_data_value=%h",
                         sensor_data_ready, sensor_data_valid, sensor_data_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sensor_data_ready=%b, sensor_data_valid=%b, sensor_data_value=%h",
                         expected_sensor_data_ready, expected_sensor_data_valid, expected_sensor_data_value);
                $display("  Got:      sensor_data_ready=%b, sensor_data_valid=%b, sensor_data_value=%h",
                         sensor_data_ready, sensor_data_valid, sensor_data_value);
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
        $dumpvars(0,clk, rst, sensor_data, sensor_sel, sensor_data_ready, sensor_data_valid, sensor_data_value);
    end

endmodule

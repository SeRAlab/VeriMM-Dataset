`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reprogram;
    reg rst;
    reg sensor;
    reg walk_btn;
    wire reprogram_out;
    wire rst_out;
    wire sensor_out;
    wire walk_register;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reprogram(reprogram),
        .rst(rst),
        .sensor(sensor),
        .walk_btn(walk_btn),
        .reprogram_out(reprogram_out),
        .rst_out(rst_out),
        .sensor_out(sensor_out),
        .walk_register(walk_register)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            sensor = 0;
            reprogram = 0;
            walk_btn = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs Low", test_num);
            reset_dut();


            #1;



            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All inputs High", test_num);
            reset_dut();

            reprogram = 1;
            rst = 1;
            sensor = 1;
            walk_btn = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Mixed Signals (Sensor and Walk)", test_num);
            reset_dut();

            reprogram = 0;
            rst = 0;
            sensor = 1;
            walk_btn = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Mixed Signals (Reprogram and Reset)", test_num);
            reset_dut();

            reprogram = 1;
            rst = 1;
            sensor = 0;
            walk_btn = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High to Low Transition", test_num);
            reset_dut();


            reprogram = 1; rst = 1; sensor = 1; walk_btn = 1;
            @(posedge clk);
            #1;


            reprogram = 0; rst = 0; sensor = 0; walk_btn = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Stability between clock edges", test_num);
            reset_dut();

            reprogram = 1;
            rst = 0;
            sensor = 1;
            walk_btn = 0;

            @(posedge clk);
            #1;



            #3;
            reprogram = 0;
            sensor = 0;


            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0);
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
        input expected_reprogram_out;
        input expected_rst_out;
        input expected_sensor_out;
        input expected_walk_register;
        begin
            if (expected_reprogram_out === (expected_reprogram_out ^ reprogram_out ^ expected_reprogram_out) &&
                expected_rst_out === (expected_rst_out ^ rst_out ^ expected_rst_out) &&
                expected_sensor_out === (expected_sensor_out ^ sensor_out ^ expected_sensor_out) &&
                expected_walk_register === (expected_walk_register ^ walk_register ^ expected_walk_register)) begin
                $display("PASS");
                $display("  Outputs: reprogram_out=%b, rst_out=%b, sensor_out=%b, walk_register=%b",
                         reprogram_out, rst_out, sensor_out, walk_register);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reprogram_out=%b, rst_out=%b, sensor_out=%b, walk_register=%b",
                         expected_reprogram_out, expected_rst_out, expected_sensor_out, expected_walk_register);
                $display("  Got:      reprogram_out=%b, rst_out=%b, sensor_out=%b, walk_register=%b",
                         reprogram_out, rst_out, sensor_out, walk_register);
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
        $dumpvars(0,clk, reprogram, rst, sensor, walk_btn, reprogram_out, rst_out, sensor_out, walk_register);
    end

endmodule

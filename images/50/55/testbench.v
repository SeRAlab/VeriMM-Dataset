`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg backward;
    reg clk_100mhz;
    reg forward;
    reg left;
    reg right;
    reg rst;
    reg [1:0] speed;
    wire [9:0] car_x;
    wire [8:0] car_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .backward(backward),
        .clk_100mhz(clk_100mhz),
        .forward(forward),
        .left(left),
        .right(right),
        .rst(rst),
        .speed(speed),
        .car_x(car_x),
        .car_y(car_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk_100mhz = 0;
        forever #5 clk_100mhz = ~clk_100mhz;
    end

        task reset_dut;

        begin
            rst = 1;
            forward = 0;
            backward = 0;
            left = 0;
            right = 0;
            speed = 0;
            repeat(5) @(posedge clk_100mhz);
            rst = 0;
            repeat(2) @(posedge clk_100mhz);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(364, 364);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Move Right (Speed 1)", test_num);
            reset_dut();
            right = 1;
            speed = 2'b01;


            repeat(200) @(posedge clk_100mhz);
            right = 0;

            #1;


            check_outputs(365, 364);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Move Left (Speed 2)", test_num);
            reset_dut();
            left = 1;
            speed = 2'b10;
            repeat(200) @(posedge clk_100mhz);
            left = 0;

            #1;


            check_outputs(362, 364);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Move Forward (Speed 3)", test_num);
            reset_dut();
            forward = 1;
            speed = 2'b11;
            repeat(200) @(posedge clk_100mhz);
            forward = 0;

            #1;


            check_outputs(364, 361);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Move Backward (Speed 1)", test_num);
            reset_dut();
            backward = 1;
            speed = 2'b01;
            repeat(200) @(posedge clk_100mhz);
            backward = 0;

            #1;


            check_outputs(364, 365);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Extended Move Right (Multiple Updates)", test_num);
            reset_dut();
            right = 1;
            speed = 2'b01;

            repeat(1000) @(posedge clk_100mhz);
            right = 0;


            #1;



            check_outputs(374, 364);
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
        input [9:0] expected_car_x;
        input [8:0] expected_car_y;
        begin
            if (expected_car_x === (expected_car_x ^ car_x ^ expected_car_x) &&
                expected_car_y === (expected_car_y ^ car_y ^ expected_car_y)) begin
                $display("PASS");
                $display("  Outputs: car_x=%h, car_y=%h",
                         car_x, car_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: car_x=%h, car_y=%h",
                         expected_car_x, expected_car_y);
                $display("  Got:      car_x=%h, car_y=%h",
                         car_x, car_y);
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
        $dumpvars(0,backward, clk_100mhz, forward, left, right, rst, speed, car_x, car_y);
    end

endmodule

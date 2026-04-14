`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] humid;
    reg [7:0] press;
    reg [1:0] sensor_select;
    reg [7:0] temp;
    wire [7:0] humid_out;
    wire [7:0] press_out;
    wire [7:0] temp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .humid(humid),
        .press(press),
        .sensor_select(sensor_select),
        .temp(temp),
        .humid_out(humid_out),
        .press_out(press_out),
        .temp_out(temp_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            temp = 8'h0;
            press = 8'h0;
            humid = 8'h0;
            sensor_select = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Temperature Sensor", test_num);
            reset_dut();

            temp = 8'hA5;
            press = 8'h22;
            humid = 8'h33;
            sensor_select = 2'b01;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00, 8'h00, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Pressure Sensor", test_num);
            reset_dut();

            temp = 8'h11;
            press = 8'h7F;
            humid = 8'h33;
            sensor_select = 2'b10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h7F, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Humidity Sensor", test_num);
            reset_dut();

            temp = 8'h11;
            press = 8'h22;
            humid = 8'hE1;
            sensor_select = 2'b11;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hE1, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Values (0xFF)", test_num);
            reset_dut();

            temp = 8'hFF;
            press = 8'hFF;
            humid = 8'hFF;
            sensor_select = 2'b01;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle State (No Sensor Selected)", test_num);
            reset_dut();

            temp = 8'h55;
            press = 8'h66;
            humid = 8'h77;
            sensor_select = 2'b00;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Switching", test_num);
            reset_dut();


            temp = 8'h10;
            sensor_select = 2'b01;
            @(posedge clk);
            #1;


            press = 8'h20;
            sensor_select = 2'b10;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00, 8'h20, 8'h00);
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
        input [7:0] expected_humid_out;
        input [7:0] expected_press_out;
        input [7:0] expected_temp_out;
        begin
            if (expected_humid_out === (expected_humid_out ^ humid_out ^ expected_humid_out) &&
                expected_press_out === (expected_press_out ^ press_out ^ expected_press_out) &&
                expected_temp_out === (expected_temp_out ^ temp_out ^ expected_temp_out)) begin
                $display("PASS");
                $display("  Outputs: humid_out=%h, press_out=%h, temp_out=%h",
                         humid_out, press_out, temp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: humid_out=%h, press_out=%h, temp_out=%h",
                         expected_humid_out, expected_press_out, expected_temp_out);
                $display("  Got:      humid_out=%h, press_out=%h, temp_out=%h",
                         humid_out, press_out, temp_out);
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
        $dumpvars(0,clk, humid, press, sensor_select, temp, humid_out, press_out, temp_out);
    end

endmodule

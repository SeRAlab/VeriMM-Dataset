`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] humidity;
    reg [15:0] pressure;
    reg [15:0] temperature;
    wire [7:0] hum_out;
    wire [15:0] press_out;
    wire [15:0] temp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .humidity(humidity),
        .pressure(pressure),
        .temperature(temperature),
        .hum_out(hum_out),
        .press_out(press_out),
        .temp_out(temp_out)
    );
    task testcase001;

        begin
            test_num = 1;
            temperature = 16'sd0;
            pressure = 16'h1234;
            humidity = 8'h55;
            #1;

            check_outputs(8'h55, 16'h1234, 16'sd32);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            temperature = 16'sd100;
            pressure = 16'hABCD;
            humidity = 8'h99;
            #1;

            check_outputs(8'h99, 16'hABCD, 16'sd212);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            temperature = -16'sd40;
            pressure = 16'h0000;
            humidity = 8'h00;
            #1;

            check_outputs(8'h00, 16'h0000, -16'sd40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            temperature = 16'sd25;
            pressure = 16'hFFFF;
            humidity = 8'hFF;
            #1;

            check_outputs(8'hFF, 16'hFFFF, 16'sd77);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            temperature = -16'sd10;
            pressure = 16'h5A5A;
            humidity = 8'hA5;
            #1;

            check_outputs(8'hA5, 16'h5A5A, 16'sd14);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            temperature = 16'sd35;
            pressure = 16'd1013;
            humidity = 8'd45;
            #1;

            check_outputs(8'd45, 16'd1013, 16'sd95);
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
        input [7:0] expected_hum_out;
        input [15:0] expected_press_out;
        input [15:0] expected_temp_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hum_out === (expected_hum_out ^ hum_out ^ expected_hum_out) &&
                expected_press_out === (expected_press_out ^ press_out ^ expected_press_out) &&
                expected_temp_out === (expected_temp_out ^ temp_out ^ expected_temp_out)) begin
                $display("PASS");
                $display("  Outputs: hum_out=%h, press_out=%h, temp_out=%h",
                         hum_out, press_out, temp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hum_out=%h, press_out=%h, temp_out=%h",
                         expected_hum_out, expected_press_out, expected_temp_out);
                $display("  Got:      hum_out=%h, press_out=%h, temp_out=%h",
                         hum_out, press_out, temp_out);
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

endmodule

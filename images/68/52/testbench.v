`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] clear;
    reg clk;
    reg [15:0] distance;
    reg sensor;
    reg subtract;
    wire [15:0] pos1;
    wire [15:0] pos2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .distance(distance),
        .sensor(sensor),
        .subtract(subtract),
        .pos1(pos1),
        .pos2(pos2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 2'b11;
            sensor = 0;
            subtract = 0;
            distance = 0;
            repeat(2) @(negedge clk);
            clear = 2'b00;
            repeat(1) @(negedge clk);
        end
        endtask
    task pulse_sensor;

        begin
            @(negedge clk);
            sensor = 1;
            @(negedge clk);
            sensor = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying reset state", test_num);
            reset_dut();
            #1;

            check_outputs(16'd0, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single sensor pulse increment", test_num);
            reset_dut();
            pulse_sensor();
            #1;

            check_outputs(16'd1, 16'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Multiple sensor pulses (15)", test_num);
            reset_dut();
            for (i = 0; i < 15; i = i + 1) begin
                pulse_sensor();
            end
            #1;

            check_outputs(16'd15, 16'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Clear pos1 only", test_num);
            reset_dut();
            repeat(5) pulse_sensor();
            @(negedge clk);
            clear = 2'b01;
            @(negedge clk);
            clear = 2'b00;
            #1;

            check_outputs(16'd0, 16'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Clear pos2 only", test_num);
            reset_dut();
            repeat(8) pulse_sensor();
            @(negedge clk);
            clear = 2'b10;
            @(negedge clk);
            clear = 2'b00;
            #1;

            check_outputs(16'd8, 16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Subtraction from pos2", test_num);
            reset_dut();
            repeat(20) pulse_sensor();
            @(negedge clk);
            distance = 16'd12;
            subtract = 1;
            @(negedge clk);
            subtract = 0;
            #1;

            check_outputs(16'd20, 16'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Subtraction resulting in underflow", test_num);
            reset_dut();
            repeat(5) pulse_sensor();
            @(negedge clk);
            distance = 16'd10;
            subtract = 1;
            @(negedge clk);
            subtract = 0;

            #1;


            check_outputs(16'd5, 16'hFFFB);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Clear with incoming pulse", test_num);
            reset_dut();
            repeat(3) pulse_sensor();
            @(negedge clk);
            clear = 2'b11;
            sensor = 1;
            @(negedge clk);
            clear = 2'b00;
            sensor = 0;

            #1;


            check_outputs(16'd0, 16'd0);
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
        input [15:0] expected_pos1;
        input [15:0] expected_pos2;
        begin
            if (expected_pos1 === (expected_pos1 ^ pos1 ^ expected_pos1) &&
                expected_pos2 === (expected_pos2 ^ pos2 ^ expected_pos2)) begin
                $display("PASS");
                $display("  Outputs: pos1=%h, pos2=%h",
                         pos1, pos2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos1=%h, pos2=%h",
                         expected_pos1, expected_pos2);
                $display("  Got:      pos1=%h, pos2=%h",
                         pos1, pos2);
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
        $dumpvars(0,clear, clk, distance, sensor, subtract, pos1, pos2);
    end

endmodule

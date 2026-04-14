`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Kd;
    reg [15:0] Ki;
    reg [15:0] Kp;
    reg clk;
    reg [15:0] measured_value;
    reg rst;
    reg [15:0] setpoint;
    wire [15:0] control_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PID_Controller dut (
        .Kd(Kd),
        .Ki(Ki),
        .Kp(Kp),
        .clk(clk),
        .measured_value(measured_value),
        .rst(rst),
        .setpoint(setpoint),
        .control_output(control_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        setpoint = 0;
        measured_value = 0;
        Kp = 0;
        Ki = 0;
        Kd = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        Kp = 16'd10;
        Ki = 16'd0;
        Kd = 16'd0;
        setpoint = 16'd100;
        measured_value = 16'd50;
        wait_cycles(1);
        $display("Test Case 001: Proportional Action");
        #1;

        check_outputs(16'd500);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        Kp = 16'd0;
        Ki = 16'd5;
        Kd = 16'd0;
        setpoint = 16'd20;
        measured_value = 16'd10;
        wait_cycles(2);
        $display("Test Case 002: Integral Action Accumulation");
        #1;

        check_outputs(16'd100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        Kp = 16'd0;
        Ki = 16'd0;
        Kd = 16'd2;
        setpoint = 16'd20;
        measured_value = 16'd0;
        wait_cycles(1);
        setpoint = 16'd30;
        measured_value = 16'd0;
        wait_cycles(1);
        $display("Test Case 003: Derivative Action");
        #1;

        check_outputs(16'd20);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        Kp = 16'd2;
        Ki = 16'd1;
        Kd = 16'd1;
        setpoint = 16'd100;
        measured_value = 16'd90;
        wait_cycles(1);
        measured_value = 16'd95;
        wait_cycles(1);
        $display("Test Case 004: Full PID Combined");
        #1;

        check_outputs(16'd20);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        Kp = 16'd1000;
        Ki = 16'd0;
        Kd = 16'd0;
        setpoint = 16'd500;
        measured_value = 16'd0;
        wait_cycles(1);
        $display("Test Case 005: Upper Saturation");
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        Kp = 16'd0;
        Ki = 16'd10;
        setpoint = 16'd10;
        measured_value = 16'd0;
        wait_cycles(5);
        reset_dut();
        Kp = 16'd1;
        setpoint = 16'd0;
        measured_value = 16'd0;
        wait_cycles(1);
        $display("Test Case 006: Reset Internal State");
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PID_Controller Testbench");
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
        input [15:0] expected_control_output;
        begin
            if (expected_control_output === (expected_control_output ^ control_output ^ expected_control_output)) begin
                $display("PASS");
                $display("  Outputs: control_output=%h",
                         control_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_output=%h",
                         expected_control_output);
                $display("  Got:      control_output=%h",
                         control_output);
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
        $dumpvars(0,Kd, Ki, Kp, clk, measured_value, rst, setpoint, control_output);
    end

endmodule

`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_value;
    reg [7:0] setpoint;
    wire [7:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PID_Controller dut (
        .clk(clk),
        .current_value(current_value),
        .setpoint(setpoint),
        .control_signal(control_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            setpoint = 8'd0;
            current_value = 8'd0;
            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            setpoint = 8'd100;
            current_value = 8'd100;
            @(posedge clk);
            #1;
            $display("Test Case 001: Zero Error State");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            setpoint = 8'd20;
            current_value = 8'd0;
            @(posedge clk);
            #1;
            $display("Test Case 002: Step Response (1st cycle)");
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            setpoint = 8'd10;
            current_value = 8'd0;
            repeat (3) @(posedge clk);
            #1;
            $display("Test Case 003: Integral Accumulation (3 cycles)");
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            setpoint = 8'd50;
            current_value = 8'd0;
            @(posedge clk);
            #1;
            current_value = 8'd40;
            @(posedge clk);
            #1;
            $display("Test Case 004: Negative Derivative Response");
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            setpoint = 8'd200;
            current_value = 8'd0;
            @(posedge clk);
            #1;
            $display("Test Case 005: Output Saturation (Max)");
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_control_signal;
        begin
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
        $dumpvars(0,clk, current_value, setpoint, control_signal);
    end

endmodule

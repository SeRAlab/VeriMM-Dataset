`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measured_value;
    reg [15:0] setpoint;
    wire [15:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PID_Controller dut (
        .clk(clk),
        .measured_value(measured_value),
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
            rst_n = 0;
            measured_value = 0;
            setpoint = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Proportional and Derivative Initial Step", test_num);
            reset_dut();
            setpoint = 16'd100;
            measured_value = 16'd80;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd80);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Zero Error Condition", test_num);
            reset_dut();
            setpoint = 16'd50;
            measured_value = 16'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Integral Accumulation Over Time", test_num);
            reset_dut();
            setpoint = 16'd10;
            measured_value = 16'd0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Negative Error Response", test_num);
            reset_dut();
            setpoint = 16'd10;
            measured_value = 16'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFD8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Derivative Response to Change", test_num);
            reset_dut();
            setpoint = 16'd100;
            measured_value = 16'd100;
            @(posedge clk);
            measured_value = 16'd90;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd40);
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
        input [15:0] expected_control_signal;
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
        $dumpvars(0,clk, measured_value, setpoint, control_signal);
    end

endmodule

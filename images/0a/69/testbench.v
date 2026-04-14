`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Kd;
    reg [15:0] Ki;
    reg [15:0] Kp;
    reg clk;
    reg [15:0] process_variable;
    reg reset;
    reg [15:0] setpoint;
    wire [31:0] control_signal;

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
        .process_variable(process_variable),
        .reset(reset),
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
            reset = 1;
            Kp = 0;
            Ki = 0;
            Kd = 0;
            setpoint = 0;
            process_variable = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Proportional Only");
            reset_dut();
            test_num = test_num + 1;
            Kp = 16'd5;
            Ki = 16'd0;
            Kd = 16'd0;
            setpoint = 16'd200;
            process_variable = 16'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd500);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Integral Only (Accumulation)");
            reset_dut();
            test_num = test_num + 1;
            Kp = 16'd0;
            Ki = 16'd2;
            Kd = 16'd0;
            setpoint = 16'd50;
            process_variable = 16'd40;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd40);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Derivative Only (Rate of Change)");
            reset_dut();
            test_num = test_num + 1;
            Kp = 16'd0;
            Ki = 16'd0;
            Kd = 16'd10;


            setpoint = 16'd20;
            process_variable = 16'd0;
            @(posedge clk);


            setpoint = 16'd20;
            process_variable = 16'd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFCE);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Full PID Combined");
            reset_dut();
            test_num = test_num + 1;
            Kp = 16'd2;
            Ki = 16'd1;
            Kd = 16'd1;

            setpoint = 16'd100;
            process_variable = 16'd80;
            @(posedge clk);

            setpoint = 16'd100;
            process_variable = 16'd90;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd40);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Zero Error");
            reset_dut();
            test_num = test_num + 1;
            Kp = 16'd10;
            Ki = 16'd0;
            Kd = 16'd5;
            setpoint = 16'd500;
            process_variable = 16'd500;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Negative Error");
            reset_dut();
            test_num = test_num + 1;
            Kp = 16'd2;
            Ki = 16'd0;
            Kd = 16'd0;
            setpoint = 16'd100;
            process_variable = 16'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFF9C);
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
        input [31:0] expected_control_signal;
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
        $dumpvars(0,Kd, Ki, Kp, clk, process_variable, reset, setpoint, control_signal);
    end

endmodule

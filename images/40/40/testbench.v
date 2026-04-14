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
        .process_variable(process_variable),
        .reset(reset),
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
            reset = 1;
            Kp = 0;
            Ki = 0;
            Kd = 0;
            setpoint = 0;
            process_variable = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pure Proportional Control", test_num);
            reset_dut();
            Kp = 16'h000A;
            Ki = 16'h0000;
            Kd = 16'h0000;
            setpoint = 16'd100;
            process_variable = 16'd50;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h01F4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Integral Accumulation", test_num);
            reset_dut();
            Kp = 16'h0000;
            Ki = 16'h0005;
            Kd = 16'h0000;
            setpoint = 16'd100;
            process_variable = 16'd90;

            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0064);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Derivative Action (Error Difference)", test_num);
            reset_dut();
            Kp = 16'h0000;
            Ki = 16'h0000;
            Kd = 16'h000A;
            setpoint = 16'd100;
            process_variable = 16'd90;
            @(posedge clk);
            #1;

            process_variable = 16'd85;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0032);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full PID Combination", test_num);
            reset_dut();
            Kp = 16'h0002;
            Ki = 16'h0001;
            Kd = 16'h0001;
            setpoint = 16'd100;
            process_variable = 16'd90;

            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0028);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper Saturation Limit", test_num);
            reset_dut();
            Kp = 16'h03E8;
            Ki = 16'h0000;
            Kd = 16'h0000;
            setpoint = 16'd1000;
            process_variable = 16'd0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h7FFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower Saturation Limit", test_num);
            reset_dut();
            Kp = 16'h03E8;
            Ki = 16'h0000;
            Kd = 16'h0000;
            setpoint = 16'd0;
            process_variable = 16'd1000;

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h8000);
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
        $dumpvars(0,Kd, Ki, Kp, clk, process_variable, reset, setpoint, control_output);
    end

endmodule

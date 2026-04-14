`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Kd;
    reg [7:0] Ki;
    reg [7:0] Kp;
    reg clk;
    reg [7:0] measured_value;
    reg reset;
    reg [7:0] setpoint;
    wire [15:0] pid_output;

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
        .reset(reset),
        .setpoint(setpoint),
        .pid_output(pid_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Kd = 0; Ki = 0; Kp = 0;
            measured_value = 0;
            setpoint = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Zero Error", test_num);
            Kp = 8'd10; Ki = 8'd5; Kd = 8'd2;
            setpoint = 8'd100;
            measured_value = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Proportional Only", test_num);
            Kp = 8'd5; Ki = 8'd0; Kd = 8'd0;
            setpoint = 8'd50;
            measured_value = 8'd40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0032);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Integral Only Accumulation", test_num);
            Kp = 8'd0; Ki = 8'd2; Kd = 8'd0;
            setpoint = 8'd20;
            measured_value = 8'd10;


            @(posedge clk);

            @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h003C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Derivative Component", test_num);
            Kp = 8'd0; Ki = 8'd0; Kd = 8'd5;


            setpoint = 8'd100;
            measured_value = 8'd90;
            @(posedge clk);


            setpoint = 8'd100;
            measured_value = 8'd88;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Full PID Calculation", test_num);
            Kp = 8'd2; Ki = 8'd1; Kd = 8'd1;



            setpoint = 8'd20;
            measured_value = 8'd10;
            @(posedge clk);



            setpoint = 8'd20;
            measured_value = 8'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0014);
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
        input [15:0] expected_pid_output;
        begin
            if (expected_pid_output === (expected_pid_output ^ pid_output ^ expected_pid_output)) begin
                $display("PASS");
                $display("  Outputs: pid_output=%h",
                         pid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pid_output=%h",
                         expected_pid_output);
                $display("  Got:      pid_output=%h",
                         pid_output);
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
        $dumpvars(0,Kd, Ki, Kp, clk, measured_value, reset, setpoint, pid_output);
    end

endmodule

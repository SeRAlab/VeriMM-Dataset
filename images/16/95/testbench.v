`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control_gain;
    reg [15:0] current_state;
    reg rst;
    reg [15:0] setpoint;
    wire [15:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .clk(clk),
        .control_gain(control_gain),
        .current_state(current_state),
        .rst(rst),
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
            rst = 1;
            setpoint = 0;
            current_state = 0;
            control_gain = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Positive Control");
            reset_dut();
            setpoint = 16'd100;
            current_state = 16'd50;
            control_gain = 16'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Negative Control (Signed)");
            reset_dut();
            setpoint = 16'd50;
            current_state = 16'd100;
            control_gain = 16'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFF06);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Zero Error");
            reset_dut();
            setpoint = 16'd200;
            current_state = 16'd200;
            control_gain = 16'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Zero Gain");
            reset_dut();
            setpoint = 16'd100;
            current_state = 16'd0;
            control_gain = 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Positive Clamping");
            reset_dut();
            setpoint = 16'd1000;
            current_state = 16'd0;
            control_gain = 16'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Negative Clamping");
            reset_dut();
            setpoint = 16'd0;
            current_state = 16'd1000;
            control_gain = 16'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Sequential Update");
            reset_dut();
            setpoint = 16'd100;
            current_state = 16'd0;
            control_gain = 16'd1;
            @(posedge clk);
            #1;
            $display("  Step 1 check:");
            if (control_signal == 16'd100) pass_count = pass_count + 1;
            else fail_count = fail_count + 1;

            current_state = 16'd80;
            @(posedge clk);
            #1;
            $display("  Step 2 check:");
            #1;

            check_outputs(16'd20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, control_gain, current_state, rst, setpoint, control_signal);
    end

endmodule

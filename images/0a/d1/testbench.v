`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] error;
    reg rst;
    wire [31:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PID_Controller dut (
        .clk(clk),
        .error(error),
        .rst(rst),
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
            error = 0;
            test_num = test_num + 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Zero Error...");
            reset_dut();
            error = 16'h0000;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Step Input (Initial Reaction)...");
            reset_dut();
            error = 16'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Steady State Error (Integral Action)...");
            reset_dut();
            error = 16'd10;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd40);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Error Decrease (Derivative Braking)...");
            reset_dut();
            error = 16'd20;
            @(posedge clk);
            error = 16'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Negative Error...");
            reset_dut();
            error = -16'd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFF1);
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
        $dumpvars(0,clk, error, rst, control_signal);
    end

endmodule

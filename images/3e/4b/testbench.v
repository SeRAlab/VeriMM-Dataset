`timescale 1ns/1ps

module LDO_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] feedback_voltage;
    reg [7:0] ref_voltage;
    reg reset;
    wire gate_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Controller dut (
        .clk(clk),
        .feedback_voltage(feedback_voltage),
        .ref_voltage(ref_voltage),
        .reset(reset),
        .gate_signal(gate_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            feedback_voltage = 8'd0;
            ref_voltage = 8'd0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Under-voltage (FB < REF)");
            reset_dut();
            ref_voltage = 8'd150;
            feedback_voltage = 8'd100;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Over-voltage (FB > REF)");
            reset_dut();
            ref_voltage = 8'd100;
            feedback_voltage = 8'd200;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Equilibrium (FB == REF)");
            reset_dut();
            ref_voltage = 8'd128;
            feedback_voltage = 8'd128;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Low Voltage Regulation");
            reset_dut();
            ref_voltage = 8'd10;
            feedback_voltage = 8'd5;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: High Voltage Regulation");
            reset_dut();
            ref_voltage = 8'hFF;
            feedback_voltage = 8'hFE;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Controller Testbench");
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
        input expected_gate_signal;
        begin
            if (expected_gate_signal === (expected_gate_signal ^ gate_signal ^ expected_gate_signal)) begin
                $display("PASS");
                $display("  Outputs: gate_signal=%b",
                         gate_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gate_signal=%b",
                         expected_gate_signal);
                $display("  Got:      gate_signal=%b",
                         gate_signal);
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
        $dumpvars(0,clk, feedback_voltage, ref_voltage, reset, gate_signal);
    end

endmodule

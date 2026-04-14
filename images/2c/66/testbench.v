`timescale 1ns/1ps

module vco_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control_voltage;
    wire [7:0] frequency_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vco dut (
        .clk(clk),
        .control_voltage(control_voltage),
        .frequency_out(frequency_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        control_voltage <= 4'b0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("\nTest Case 001: Minimum Voltage (0)");
        reset_dut();
        control_voltage <= 4'd0;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        $display("\nTest Case 002: Low Voltage (1)");
        reset_dut();
        control_voltage <= 4'd1;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd16);
    end
        endtask

    task testcase003;

    begin
        $display("\nTest Case 003: Mid-range Voltage (8)");
        reset_dut();
        control_voltage <= 4'd8;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase004;

    begin
        $display("\nTest Case 004: High Voltage (12)");
        reset_dut();
        control_voltage <= 4'd12;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd192);
    end
        endtask

    task testcase005;

    begin
        $display("\nTest Case 005: Maximum Voltage (15)");
        reset_dut();
        control_voltage <= 4'd15;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd240);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vco Testbench");
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
        input [7:0] expected_frequency_out;
        begin
            if (expected_frequency_out === (expected_frequency_out ^ frequency_out ^ expected_frequency_out)) begin
                $display("PASS");
                $display("  Outputs: frequency_out=%h",
                         frequency_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_out=%h",
                         expected_frequency_out);
                $display("  Got:      frequency_out=%h",
                         frequency_out);
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
        $dumpvars(0,clk, control_voltage, frequency_out);
    end

endmodule

`timescale 1ns/1ps

module pulse_generator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] PERIOD;
    reg [3:0] PULSE_WIDTH;
    reg clk;
    reg enable;
    wire pulse_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pulse_generator dut (
        .PERIOD(PERIOD),
        .PULSE_WIDTH(PULSE_WIDTH),
        .clk(clk),
        .enable(enable),
        .pulse_out(pulse_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        PERIOD = 0;
        PULSE_WIDTH = 0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        PERIOD = 4'd8;
        PULSE_WIDTH = 4'd3;
        enable = 1;
        @(posedge clk);
        #2;
        $display("Test 001: Basic Pulse - High Phase");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        PERIOD = 4'd8;
        PULSE_WIDTH = 4'd3;
        enable = 1;
        repeat(6) @(posedge clk);
        #2;
        $display("Test 002: Basic Pulse - Low Phase");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        PERIOD = 4'd4;
        PULSE_WIDTH = 4'd2;
        enable = 0;
        repeat(5) @(posedge clk);
        #2;
        $display("Test 003: Enable Low Check");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        PERIOD = 4'd5;
        PULSE_WIDTH = 4'd5;
        enable = 1;
        repeat(10) @(posedge clk);
        #2;
        $display("Test 004: Max Pulse Width (100%% Duty Cycle)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        PERIOD = 4'd6;
        PULSE_WIDTH = 4'd0;
        enable = 1;
        repeat(4) @(posedge clk);
        #2;
        $display("Test 005: Zero Pulse Width");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        PERIOD = 4'd4;
        PULSE_WIDTH = 4'd1;
        enable = 1;
        repeat(9) @(posedge clk);
        #2;
        $display("Test 006: Multi-period Wrap-around (Cycle 8)");
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
        $display("pulse_generator Testbench");
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
        input expected_pulse_out;
        begin
            if (expected_pulse_out === (expected_pulse_out ^ pulse_out ^ expected_pulse_out)) begin
                $display("PASS");
                $display("  Outputs: pulse_out=%b",
                         pulse_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse_out=%b",
                         expected_pulse_out);
                $display("  Got:      pulse_out=%b",
                         pulse_out);
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
        $dumpvars(0,PERIOD, PULSE_WIDTH, clk, enable, pulse_out);
    end

endmodule

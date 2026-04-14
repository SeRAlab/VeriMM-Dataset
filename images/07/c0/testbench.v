`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] step_size;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .step_size(step_size),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        d = 0;
        x = 0;
        step_size = 0;
        repeat(5) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Zero Input...");
        reset_dut();
        step_size = 16'h0100;
        x = 16'h0000;
        d = 16'h0000;
        repeat(50) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: DC Convergence (Unity)...");
        reset_dut();
        step_size = 16'h0400;
        x = 16'h1000;
        d = 16'h1000;

        repeat(200) @(posedge clk);
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Negative DC Convergence...");
        reset_dut();
        step_size = 16'h0400;
        x = 16'h1000;
        d = 16'hF000;
        repeat(500) @(posedge clk);
        #1;

        check_outputs(16'hF000);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Scaling (Gain of 0.5)...");
        reset_dut();
        step_size = 16'h0200;
        x = 16'h2000;
        d = 16'h1000;
        repeat(500) @(posedge clk);
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Zero Step Size...");
        reset_dut();
        step_size = 16'h0000;
        x = 16'h2000;
        d = 16'h2000;
        repeat(100) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adaptive_lms_filter Testbench");
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
        input [15:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, d, reset, step_size, x, y);
    end

endmodule

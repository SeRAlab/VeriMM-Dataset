`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] timeout_value;
    wire timeout_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .reset(reset),
        .timeout_value(timeout_value),
        .timeout_output(timeout_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        timeout_value = 4'd0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase 001: Standard Timeout Trigger");
        reset_dut();
        timeout_value = 4'd5;

        repeat(6) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase 002: Prevent Timeout via Reset Pulse");
        reset_dut();
        timeout_value = 4'd8;
        repeat(4) @(posedge clk);


        reset = 1;
        @(posedge clk);
        #1 reset = 0;


        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase 003: Maximum Timeout Value (15)");
        reset_dut();
        timeout_value = 4'd15;
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase 004: Clearing Triggered Timeout Output");
        reset_dut();
        timeout_value = 4'd3;
        repeat(4) @(posedge clk);


        reset = 1;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase 005: Minimum Timeout Value (1)");
        reset_dut();
        timeout_value = 4'd1;
        repeat(2) @(posedge clk);
        #1;
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
        $display("watchdog_timer Testbench");
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
        input expected_timeout_output;
        begin
            if (expected_timeout_output === (expected_timeout_output ^ timeout_output ^ expected_timeout_output)) begin
                $display("PASS");
                $display("  Outputs: timeout_output=%b",
                         timeout_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timeout_output=%b",
                         expected_timeout_output);
                $display("  Got:      timeout_output=%b",
                         timeout_output);
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
        $dumpvars(0,clk, reset, timeout_value, timeout_output);
    end

endmodule

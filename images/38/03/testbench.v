`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [15:0] max_value;
    reg rst;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .enable(enable),
        .max_value(max_value),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        enable = 0;
        max_value = 16'hFFFF;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Reset Check");
        reset_dut();

        #1 #1;
 check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Basic Increment");
        reset_dut();
        max_value = 16'd100;
        enable = 1;
        repeat(10) @(posedge clk);
        enable = 0;
        #1 #1;
 check_outputs(16'd10);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Wrap-around at max_value");
        reset_dut();
        max_value = 16'd5;
        enable = 1;

        repeat(6) @(posedge clk);
        enable = 0;
        #1 #1;
 check_outputs(16'd0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Enable Gating Logic");
        reset_dut();
        max_value = 16'hFFFF;
        enable = 1;
        repeat(5) @(posedge clk);
        enable = 0;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(16'd5);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Boundary Max Value (0xFFFF)");
        reset_dut();
        max_value = 16'hFFFF;
        enable = 1;

        repeat(500) @(posedge clk);
        enable = 0;
        #1 #1;
 check_outputs(16'd500);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Asynchronous-like Synchronous Reset during counting");
        reset_dut();
        max_value = 16'd100;
        enable = 1;
        repeat(20) @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        #1 #1;
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
        $display("timer Testbench");
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
        input [15:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, enable, max_value, rst, count);
    end

endmodule

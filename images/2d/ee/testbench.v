`timescale 1ns/1ps

module timer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [15:0] max_count;
    reg reset;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer_16bit dut (
        .clk(clk),
        .enable(enable),
        .max_count(max_count),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        max_count = 16'h0000;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Basic Counting");
        reset_dut();
        max_count = 16'h00FF;
        enable = 1;

        repeat(10) @(posedge clk);
        enable = 0;
        #1 #1;
 check_outputs(16'd10);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Wrap Around Logic");
        reset_dut();
        max_count = 16'h0005;
        enable = 1;

        repeat(6) @(posedge clk);
        enable = 0;
        #1 #1;
 check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Enable Gating");
        reset_dut();
        max_count = 16'hFFFF;
        enable = 1;
        repeat(5) @(posedge clk);
        enable = 0;
        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(16'd5);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Reset mid-counting");
        reset_dut();
        max_count = 16'h00FF;
        enable = 1;
        repeat(20) @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        #1 #1;
 check_outputs(16'd0);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Large max_count Wrap");
        reset_dut();
        max_count = 16'd1000;
        enable = 1;
        repeat(1000) @(posedge clk);
        #1 #1;
 check_outputs(16'd1000);
        @(posedge clk);
        enable = 0;
        #1 #1;
 check_outputs(16'd0);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning testcase006: Dynamic max_count change");
        reset_dut();
        max_count = 16'd50;
        enable = 1;
        repeat(10) @(posedge clk);
        max_count = 16'd15;
        repeat(6) @(posedge clk);
        enable = 0;
        #1 #1;
 check_outputs(16'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer_16bit Testbench");
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
        $dumpvars(0,clk, enable, max_count, reset, count);
    end

endmodule

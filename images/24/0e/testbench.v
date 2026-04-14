`timescale 1ns/1ps

module DWT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg valid;
    reg [15:0] x0;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    wire [15:0] a0;
    wire [15:0] d0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT dut (
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .a0(a0),
        .d0(d0)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        valid = 0;
        x0 = 0;
        x1 = 0;
        x2 = 0;
        x3 = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: All zeros");
        reset_dut();
        test_num = 1;
        x0 = 16'h0000; x1 = 16'h0000; x2 = 16'h0000; x3 = 16'h0000;
        valid = 1;
        @(posedge clk);
        valid = 0;
        #1 #1;
 check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Constant sequence");
        reset_dut();
        test_num = 2;
        x0 = 16'd100; x1 = 16'd100; x2 = 16'd100; x3 = 16'd100;
        valid = 1;
        @(posedge clk);
        valid = 0;
        #1 #1;
 check_outputs(16'd200, 16'd0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Alternating sequence");
        reset_dut();
        test_num = 3;
        x0 = 16'sd100; x1 = -16'sd100; x2 = 16'sd100; x3 = -16'sd100;
        valid = 1;
        @(posedge clk);
        valid = 0;
        #1 #1;
 check_outputs(16'sd0, 16'sd200);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Impulse at X0");
        reset_dut();
        test_num = 4;
        x0 = 16'd100; x1 = 0; x2 = 0; x3 = 0;
        valid = 1;
        @(posedge clk);
        valid = 0;
        #1 #1;
 check_outputs(16'd50, 16'd50);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Impulse at X1");
        reset_dut();
        test_num = 5;
        x0 = 0; x1 = 16'd100; x2 = 0; x3 = 0;
        valid = 1;
        @(posedge clk);
        valid = 0;
        #1 #1;
 check_outputs(16'sd50, -16'sd50);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Ramp signal");
        reset_dut();
        test_num = 6;
        x0 = 16'd10; x1 = 16'd20; x2 = 16'd30; x3 = 16'd40;
        valid = 1;
        @(posedge clk);
        valid = 0;
        #1 #1;
 check_outputs(16'sd50, -16'sd10);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Large values");
        reset_dut();
        test_num = 7;
        x0 = 16'd10000; x1 = 16'd10000; x2 = 16'd10000; x3 = 16'd10000;
        valid = 1;
        @(posedge clk);
        valid = 0;
        #1 #1;
 check_outputs(16'd20000, 16'd0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Truncation check");
        reset_dut();
        test_num = 8;
        x0 = 16'd1; x1 = 16'd1; x2 = 16'd1; x3 = 16'd0;
        valid = 1;
        @(posedge clk);
        valid = 0;
        #1 #1;
 check_outputs(16'd1, 16'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_a0;
        input [15:0] expected_d0;
        begin
            if (expected_a0 === (expected_a0 ^ a0 ^ expected_a0) &&
                expected_d0 === (expected_d0 ^ d0 ^ expected_d0)) begin
                $display("PASS");
                $display("  Outputs: a0=%h, d0=%h",
                         a0, d0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a0=%h, d0=%h",
                         expected_a0, expected_d0);
                $display("  Got:      a0=%h, d0=%h",
                         a0, d0);
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
        $dumpvars(0,clk, rst, valid, x0, x1, x2, x3, a0, d0);
    end

endmodule

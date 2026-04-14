`timescale 1ns/1ps

module lfsr_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32bit dut (
        .clk(clk),
        .rst(rst),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Checking reset state...");
        reset_dut();


        if (lfsr_out !== 32'h0) begin
            $display("DUT reset to: %h", lfsr_out);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: LFSR reset to zero (invalid for PRNG)");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase002;

    reg [31:0] seed;
    reg [31:0] expected;
    begin
        test_num = 2;
        $display("Testcase 002: Checking state after 1 clock cycle...");
        reset_dut();
        seed = lfsr_out;
        expected = predict_lfsr(seed);
        @(posedge clk);
        #1;
        #1;

        check_outputs(expected);
    end
        endtask

    task testcase003;

    reg [31:0] seed;
    reg [31:0] expected;
    integer i;
    begin
        test_num = 3;
        $display("Testcase 003: Checking state after 10 clock cycles...");
        reset_dut();
        seed = lfsr_out;
        expected = seed;
        repeat(10) begin
            expected = predict_lfsr(expected);
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(expected);
    end
        endtask

    task testcase004;

    reg [31:0] seed;
    reg [31:0] expected;
    integer i;
    begin
        test_num = 4;
        $display("Testcase 004: Checking state after 100 clock cycles...");
        reset_dut();
        seed = lfsr_out;
        expected = seed;
        repeat(100) begin
            expected = predict_lfsr(expected);
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(expected);
    end
        endtask

    task testcase005;

    reg [31:0] val_start;
    begin
        test_num = 5;
        $display("Testcase 005: Verifying LFSR is shifting (Current != Previous)...");
        reset_dut();
        val_start = lfsr_out;
        repeat(5) @(posedge clk);
        #1;
        if (lfsr_out != val_start) begin
            $display("PASS: LFSR is progressing. Value: %h", lfsr_out);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: LFSR is stuck at %h", lfsr_out);
            fail_count = fail_count + 1;
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_32bit Testbench");
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
        input [31:0] expected_lfsr_out;
        begin
            if (expected_lfsr_out === (expected_lfsr_out ^ lfsr_out ^ expected_lfsr_out)) begin
                $display("PASS");
                $display("  Outputs: lfsr_out=%h",
                         lfsr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr_out=%h",
                         expected_lfsr_out);
                $display("  Got:      lfsr_out=%h",
                         lfsr_out);
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
        $dumpvars(0,clk, rst, lfsr_out);
    end

endmodule

`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] data_in;
    reg rst;
    reg start;
    wire [255:0] hash_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256 dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .hash_out(hash_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start = 0;
        data_in = 0;
        @(posedge clk);
        #2;
        rst = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Test Case %0d: Hash of 'abc'...", test_num);
        data_in = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
        start = 1;
        @(posedge clk);
        #2 start = 0;


        wait(ready === 1);
        @(posedge clk);
        #1;

        check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Test Case %0d: Hash of Empty Message...", test_num);
        data_in = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        start = 1;
        @(posedge clk);
        #2 start = 0;

        wait(ready === 1);
        @(posedge clk);
        #1;

        check_outputs(256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Test Case %0d: Hash of 'abcd'...", test_num);
        data_in = 512'h61626364800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020;
        start = 1;
        @(posedge clk);
        #2 start = 0;

        wait(ready === 1);
        @(posedge clk);
        #1;

        check_outputs(256'h88d4266fd4e6338d13b845fcf289579d209c897823b9217da3e161936f031589, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [255:0] expected_hash_out;
        input expected_ready;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h, ready=%b",
                         hash_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h, ready=%b",
                         expected_hash_out, expected_ready);
                $display("  Got:      hash_out=%h, ready=%b",
                         hash_out, ready);
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
        $dumpvars(0,clk, data_in, rst, start, hash_out, ready);
    end

endmodule

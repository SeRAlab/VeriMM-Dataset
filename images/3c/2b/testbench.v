`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    reg start;
    wire [127:0] hash;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .message(message),
        .reset(reset),
        .start(start),
        .hash(hash),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            message = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);

            while (ready !== 1'b1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: MD5 of empty string (padded)", test_num);
            reset_dut();
            message = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            start = 1;
            @(posedge clk);
            start = 0;
            @(posedge clk);
            while (ready !== 1'b1) @(posedge clk);
            #1;

            check_outputs(128'hd41d8cd98f00b204e9800998ecf8427e, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: MD5 of 'a' (padded)", test_num);
            reset_dut();
            message = 512'h61800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000;
            start = 1;
            @(posedge clk);
            start = 0;
            @(posedge clk);
            while (ready !== 1'b1) @(posedge clk);
            #1;

            check_outputs(128'h0cc175b9c0f1b6a831c399e269772661, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: MD5 of 'abc' (padded)", test_num);
            reset_dut();
            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018000000;
            start = 1;
            @(posedge clk);
            start = 0;
            @(posedge clk);
            while (ready !== 1'b1) @(posedge clk);
            #1;

            check_outputs(128'h900150983cd24fb0d6963f7d28e17f72, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: MD5 of 'message digest' (padded)", test_num);
            reset_dut();
            message = 512'h6d657373616765206469676573748000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000;
            start = 1;
            @(posedge clk);
            start = 0;
            @(posedge clk);
            while (ready !== 1'b1) @(posedge clk);
            #1;

            check_outputs(128'hf96b697d7cb7938d525a2f31aaf161d0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [127:0] expected_hash;
        input expected_ready;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, ready=%b",
                         hash, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, ready=%b",
                         expected_hash, expected_ready);
                $display("  Got:      hash=%h, ready=%b",
                         hash, ready);
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
        $dumpvars(0,clk, message, reset, start, hash, ready);
    end

endmodule

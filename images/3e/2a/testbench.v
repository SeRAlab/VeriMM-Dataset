`timescale 1ns/1ps

module jpeg_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] pixel_block;
    reg reset;
    reg start;
    wire [15:0] compressed_output;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_compressor dut (
        .clk(clk),
        .pixel_block(pixel_block),
        .reset(reset),
        .start(start),
        .compressed_output(compressed_output),
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
            pixel_block = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: All Zeros");
            reset_dut();
            test_num = test_num + 1;
            pixel_block = 64'h0000000000000000;
            start = 1;
            @(posedge clk);
            start = 0;


            while (!ready) @(posedge clk);
            #1;

            check_outputs(16'h0000, 1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Maximum Values (0xFF)");
            reset_dut();
            test_num = test_num + 1;
            pixel_block = 64'hFFFFFFFFFFFFFFFF;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!ready) @(posedge clk);
            #1;

            check_outputs(16'h07F8, 1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Incremental Sequence (1 to 8)");
            reset_dut();
            test_num = test_num + 1;
            pixel_block = 64'h0102030405060708;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!ready) @(posedge clk);
            #1;

            check_outputs(16'h0024, 1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Alternating Bit Patterns (AA/55)");
            reset_dut();
            test_num = test_num + 1;
            pixel_block = 64'hAA55AA55AA55AA55;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!ready) @(posedge clk);
            #1;

            check_outputs(16'h03FC, 1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Single Active Pixel");
            reset_dut();
            test_num = test_num + 1;
            pixel_block = 64'h8000000000000000;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!ready) @(posedge clk);
            #1;

            check_outputs(16'h0080, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jpeg_compressor Testbench");
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
        input [15:0] expected_compressed_output;
        input expected_ready;
        begin
            if (expected_compressed_output === (expected_compressed_output ^ compressed_output ^ expected_compressed_output) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: compressed_output=%h, ready=%b",
                         compressed_output, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_output=%h, ready=%b",
                         expected_compressed_output, expected_ready);
                $display("  Got:      compressed_output=%h, ready=%b",
                         compressed_output, ready);
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
        $dumpvars(0,clk, pixel_block, reset, start, compressed_output, ready);
    end

endmodule

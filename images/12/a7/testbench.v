`timescale 1ns/1ps

module LZW_Compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire [15:0] compressed_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW_Compressor dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .compressed_out(compressed_out),
        .valid_out(valid_out)
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
            data_in = 8'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task feed_char;

        input [7:0] char;
        begin
            data_in = char;
            start = 1;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            $display("\nRunning Testcase 001: Single Character 'A'");
            reset_dut();
            feed_char(8'h41);
            start = 0;
            @(posedge clk);
            while(!valid_out) @(posedge clk);
            #1;

            check_outputs(16'h0041, 1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Sequence ABABABA");
            reset_dut();
            feed_char(8'h41);
            feed_char(8'h42);
            feed_char(8'h41);
            feed_char(8'h42);
            feed_char(8'h41);
            feed_char(8'h42);
            feed_char(8'h41);
            start = 0;
            @(posedge clk);
            while(!valid_out) @(posedge clk);
            #1;

            check_outputs(16'd258, 1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Sequence AAAAA");
            reset_dut();
            feed_char(8'h41);
            feed_char(8'h41);
            feed_char(8'h41);
            feed_char(8'h41);
            feed_char(8'h41);
            start = 0;
            @(posedge clk);
            while(!valid_out) @(posedge clk);
            #1;

            check_outputs(16'd256, 1);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Sequence ABABAB");
            reset_dut();
            feed_char(8'h41);
            feed_char(8'h42);
            feed_char(8'h41);
            feed_char(8'h42);
            feed_char(8'h41);
            feed_char(8'h42);
            start = 0;
            @(posedge clk);
            while(!valid_out) @(posedge clk);
            #1;

            check_outputs(16'd256, 1);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Sequence AAAAAA");
            reset_dut();
            feed_char(8'h41);
            feed_char(8'h41);
            feed_char(8'h41);
            feed_char(8'h41);
            feed_char(8'h41);
            feed_char(8'h41);
            start = 0;
            @(posedge clk);
            while(!valid_out) @(posedge clk);
            #1;

            check_outputs(16'd257, 1);
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Sequence ABCABCA");
            reset_dut();
            feed_char(8'h41);
            feed_char(8'h42);
            feed_char(8'h43);
            feed_char(8'h41);
            feed_char(8'h42);
            feed_char(8'h43);
            feed_char(8'h41);
            start = 0;
            @(posedge clk);
            while(!valid_out) @(posedge clk);
            #1;

            check_outputs(16'd258, 1);
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LZW_Compressor Testbench");
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
        input [15:0] expected_compressed_out;
        input expected_valid_out;
        begin
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h, valid_out=%b",
                         compressed_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h, valid_out=%b",
                         expected_compressed_out, expected_valid_out);
                $display("  Got:      compressed_out=%h, valid_out=%b",
                         compressed_out, valid_out);
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
        $dumpvars(0,clk, data_in, reset, start, compressed_out, valid_out);
    end

endmodule

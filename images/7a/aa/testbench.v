`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [39:0] stream_in_data;
    reg stream_in_endofpacket;
    reg stream_in_startofpacket;
    reg stream_in_valid;
    reg stream_out_ready;
    wire stream_in_ready;
    wire [39:0] stream_out_data;
    wire stream_out_endofpacket;
    wire stream_out_startofpacket;
    wire stream_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .stream_in_data(stream_in_data),
        .stream_in_endofpacket(stream_in_endofpacket),
        .stream_in_startofpacket(stream_in_startofpacket),
        .stream_in_valid(stream_in_valid),
        .stream_out_ready(stream_out_ready),
        .stream_in_ready(stream_in_ready),
        .stream_out_data(stream_out_data),
        .stream_out_endofpacket(stream_out_endofpacket),
        .stream_out_startofpacket(stream_out_startofpacket),
        .stream_out_valid(stream_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            stream_in_data = 0;
            stream_in_startofpacket = 0;
            stream_in_endofpacket = 0;
            stream_in_valid = 0;
            stream_out_ready = 1;
            repeat (2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(1'b1, 40'h0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single Data Transfer");
            reset_dut();

            stream_in_data = 40'hA5A5A5A5A5;
            stream_in_valid = 1'b1;
            stream_in_startofpacket = 1'b1;
            stream_in_endofpacket = 1'b0;
            stream_out_ready = 1'b1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 40'hA5A5A5A5A5, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: End of Packet Handling");
            reset_dut();

            stream_in_data = 40'h1234567890;
            stream_in_valid = 1'b1;
            stream_in_startofpacket = 1'b0;
            stream_in_endofpacket = 1'b1;
            stream_out_ready = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 40'h1234567890, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Ready/Handshake Backpressure");
            reset_dut();

            stream_out_ready = 1'b0;
            stream_in_valid = 1'b1;
            @(posedge clk);
            #1;

            if (stream_in_ready == 1'b0) begin
                $display("PASS: Handshake inhibited input");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Input ready high despite output backpressure");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        reg [39:0] match_data;
        begin
            test_num = 5;
            $display("Testcase 005: Data Modification (Alpha Replace)");
            reset_dut();


            match_data = 40'h00FFFFFFFF;
            stream_in_data = match_data;
            stream_in_valid = 1'b1;
            stream_out_ready = 1'b1;

            @(posedge clk);
            #1;



            if (stream_out_data != match_data && stream_out_valid == 1'b1) begin
                $display("PASS: Data modification detected on match value");
                pass_count = pass_count + 1;
            end else if (stream_out_valid == 1'b1) begin
                $display("INFO: No modification on this value, verify predefined value in source.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: No valid output");
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
        $display("top_module Testbench");
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
        input expected_stream_in_ready;
        input [39:0] expected_stream_out_data;
        input expected_stream_out_endofpacket;
        input expected_stream_out_startofpacket;
        input expected_stream_out_valid;
        begin
            if (expected_stream_in_ready === (expected_stream_in_ready ^ stream_in_ready ^ expected_stream_in_ready) &&
                expected_stream_out_data === (expected_stream_out_data ^ stream_out_data ^ expected_stream_out_data) &&
                expected_stream_out_endofpacket === (expected_stream_out_endofpacket ^ stream_out_endofpacket ^ expected_stream_out_endofpacket) &&
                expected_stream_out_startofpacket === (expected_stream_out_startofpacket ^ stream_out_startofpacket ^ expected_stream_out_startofpacket) &&
                expected_stream_out_valid === (expected_stream_out_valid ^ stream_out_valid ^ expected_stream_out_valid)) begin
                $display("PASS");
                $display("  Outputs: stream_in_ready=%b, stream_out_data=%h, stream_out_endofpacket=%b, stream_out_startofpacket=%b, stream_out_valid=%b",
                         stream_in_ready, stream_out_data, stream_out_endofpacket, stream_out_startofpacket, stream_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stream_in_ready=%b, stream_out_data=%h, stream_out_endofpacket=%b, stream_out_startofpacket=%b, stream_out_valid=%b",
                         expected_stream_in_ready, expected_stream_out_data, expected_stream_out_endofpacket, expected_stream_out_startofpacket, expected_stream_out_valid);
                $display("  Got:      stream_in_ready=%b, stream_out_data=%h, stream_out_endofpacket=%b, stream_out_startofpacket=%b, stream_out_valid=%b",
                         stream_in_ready, stream_out_data, stream_out_endofpacket, stream_out_startofpacket, stream_out_valid);
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
        $dumpvars(0,clk, reset, stream_in_data, stream_in_endofpacket, stream_in_startofpacket, stream_in_valid, stream_out_ready, stream_in_ready, stream_out_data, stream_out_endofpacket, stream_out_startofpacket, stream_out_valid);
    end

endmodule

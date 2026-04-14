`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] stream_in_data;
    reg stream_in_endofpacket;
    reg stream_in_startofpacket;
    reg stream_in_valid;
    reg stream_out_ready;
    wire stream_in_ready;
    wire [15:0] stream_out_data;
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
            stream_in_data = 16'h0;
            stream_in_startofpacket = 0;
            stream_in_endofpacket = 0;
            stream_in_valid = 0;
            stream_out_ready = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Packet Transfer...");
            reset_dut();
            stream_out_ready = 1;


            @(posedge clk);
            stream_in_valid = 1;
            stream_in_startofpacket = 1;
            stream_in_data = 16'hAAAA;


            wait(stream_in_ready);


            @(posedge clk);
            stream_in_startofpacket = 0;
            stream_in_data = 16'h5555;


            @(posedge clk);
            stream_in_endofpacket = 1;
            stream_in_data = 16'hEEEE;

            @(posedge clk);
            stream_in_valid = 0;
            stream_in_endofpacket = 0;


            #1;



            check_outputs(1'b1, 16'hEEEE, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Backpressure Handling...");
            reset_dut();
            stream_out_ready = 0;

            @(posedge clk);
            stream_in_valid = 1;
            stream_in_startofpacket = 1;
            stream_in_data = 16'hB001;


            repeat(3) @(posedge clk);



            #1;




            check_outputs(1'b0, 16'hB001, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Intermittent Validity...");
            reset_dut();
            stream_out_ready = 1;

            @(posedge clk);
            stream_in_valid = 1;
            stream_in_startofpacket = 1;
            stream_in_data = 16'hC001;

            @(posedge clk);
            stream_in_valid = 0;
            stream_in_startofpacket = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 16'hC001, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Single Cycle Packet...");
            reset_dut();
            stream_out_ready = 1;

            @(posedge clk);
            stream_in_valid = 1;
            stream_in_startofpacket = 1;
            stream_in_endofpacket = 1;
            stream_in_data = 16'h1234;

            @(posedge clk);
            stream_in_valid = 0;
            stream_in_startofpacket = 0;
            stream_in_endofpacket = 0;


            #1;



            check_outputs(1'b1, 16'h1234, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset mid-packet...");
            reset_dut();
            stream_out_ready = 1;

            @(posedge clk);
            stream_in_valid = 1;
            stream_in_startofpacket = 1;
            stream_in_data = 16'hD001;

            @(posedge clk);
            reset = 1;

            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 16'h0000, 1'b0, 1'b0, 1'b0);
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
        input [15:0] expected_stream_out_data;
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

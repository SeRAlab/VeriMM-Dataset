`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send;
    wire [3:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send(send),
        .data_out(data_out),
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
        send = 0;
        ack = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Checking Initial State...");
        reset_dut();

        #1;


        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Send Single Packet...");
        reset_dut();
        @(posedge clk);
        send = 1;
        @(posedge clk);
        send = 0;
        #1;


        #1;



        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Fill Window (4 Packets)...");
        reset_dut();
        @(posedge clk);
        send = 1;
        repeat(4) @(posedge clk);
        send = 0;
        #1;


        #1;



        check_outputs(4'h3, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Sliding Window via ACK...");
        reset_dut();
        @(posedge clk);
        send = 1;
        repeat(4) @(posedge clk);
        send = 0;
        ack = 1;
        @(posedge clk);
        ack = 0;
        #1;

        #1;


        check_outputs(4'h3, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Fill, Ack, and Send Extra Packet...");
        reset_dut();
        @(posedge clk);
        send = 1;
        repeat(4) @(posedge clk);
        send = 0;
        @(posedge clk);
        ack = 1;
        @(posedge clk);
        ack = 0;
        send = 1;
        @(posedge clk);
        send = 0;
        #1;


        #1;



        check_outputs(4'h4, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Multiple ACKs to Clear Window...");
        reset_dut();
        @(posedge clk);
        send = 1;
        repeat(4) @(posedge clk);
        send = 0;
        ack = 1;
        repeat(4) @(posedge clk);
        ack = 0;
        #1;

        #1;


        check_outputs(4'h3, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_protocol Testbench");
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
        input [3:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,ack, clk, reset, send, data_out, ready);
    end

endmodule

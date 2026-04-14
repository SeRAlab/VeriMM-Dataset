`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    wire [3:0] acked_packets;
    wire [3:0] sent_packets;
    wire [3:0] state;
    wire [3:0] window_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send(send),
        .acked_packets(acked_packets),
        .sent_packets(sent_packets),
        .state(state),
        .window_size(window_size)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        send = 0;
        ack = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning Testcase 001: Reset Check");
        reset_dut();

        #1;


        check_outputs(4'h0, 4'h0, 4'h0, window_size);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: Single Packet Send");
        reset_dut();
        send = 1;
        @(posedge clk);
        send = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(4'h0, 4'h1, state, window_size);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: Single Packet Send and Ack");
        reset_dut();

        send = 1;
        @(posedge clk);
        send = 0;
        @(posedge clk);

        ack = 1;
        @(posedge clk);
        ack = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(4'h1, 4'h1, 4'h0, window_size);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Multi-packet Burst");
        reset_dut();

        repeat(3) begin
            send = 1;
            @(posedge clk);
            send = 0;
            @(posedge clk);
        end

        repeat(2) begin
            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);
        end
        #1;

        check_outputs(4'h2, 4'h3, state, window_size);
    end
        endtask

    task testcase005;

    reg [3:0] w_size;
    begin
        $display("\nRunning Testcase 005: Window Full Test");
        reset_dut();
        w_size = window_size;

        repeat(w_size) begin
            send = 1;
            @(posedge clk);
            send = 0;
            @(posedge clk);
        end

        send = 1;
        @(posedge clk);
        send = 0;
        @(posedge clk);

        #1;


        check_outputs(4'h0, w_size, state, w_size);
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
        input [3:0] expected_acked_packets;
        input [3:0] expected_sent_packets;
        input [3:0] expected_state;
        input [3:0] expected_window_size;
        begin
            if (expected_acked_packets === (expected_acked_packets ^ acked_packets ^ expected_acked_packets) &&
                expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets) &&
                expected_state === (expected_state ^ state ^ expected_state) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: acked_packets=%h, sent_packets=%h, state=%h, window_size=%h",
                         acked_packets, sent_packets, state, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_packets=%h, sent_packets=%h, state=%h, window_size=%h",
                         expected_acked_packets, expected_sent_packets, expected_state, expected_window_size);
                $display("  Got:      acked_packets=%h, sent_packets=%h, state=%h, window_size=%h",
                         acked_packets, sent_packets, state, window_size);
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
        $dumpvars(0,ack, clk, rst, send, acked_packets, sent_packets, state, window_size);
    end

endmodule

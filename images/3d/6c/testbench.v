`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_packet;
    wire [3:0] acked_packets;
    wire [3:0] sent_packets;
    wire [3:0] window_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_received(ack_received),
        .clk(clk),
        .reset(reset),
        .send_packet(send_packet),
        .acked_packets(acked_packets),
        .sent_packets(sent_packets),
        .window_size(window_size)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        send_packet = 0;
        ack_received = 0;
        test_num = test_num + 1;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase %0d: Basic Send and ACK", test_num);


        send_packet = 1;
        @(posedge clk);
        send_packet = 0;
        @(posedge clk);


        ack_received = 1;
        @(posedge clk);
        ack_received = 0;
        @(posedge clk);


        #1;



        check_outputs(4'd1, 4'd1, 4'd8);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase %0d: Fill Window Completely", test_num);


        send_packet = 1;
        repeat(8) @(posedge clk);
        send_packet = 0;
        @(posedge clk);


        #1;



        check_outputs(4'd0, 4'd8, 4'd8);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase %0d: Attempt to exceed window size", test_num);


        send_packet = 1;
        repeat(12) @(posedge clk);
        send_packet = 0;
        @(posedge clk);


        #1;



        check_outputs(4'd0, 4'd8, 4'd8);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase %0d: Sliding the window", test_num);


        send_packet = 1;
        repeat(8) @(posedge clk);
        send_packet = 0;


        ack_received = 1;
        repeat(4) @(posedge clk);
        ack_received = 0;


        send_packet = 1;
        repeat(2) @(posedge clk);
        send_packet = 0;
        @(posedge clk);


        #1;



        check_outputs(4'd4, 4'd10, 4'd8);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase %0d: Interleaved traffic", test_num);


        send_packet = 1;
        repeat(2) @(posedge clk);
        send_packet = 0;


        ack_received = 1;
        @(posedge clk);
        ack_received = 0;


        send_packet = 1;
        repeat(3) @(posedge clk);
        send_packet = 0;


        ack_received = 1;
        repeat(2) @(posedge clk);
        ack_received = 0;
        @(posedge clk);


        #1;



        check_outputs(4'd3, 4'd5, 4'd8);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase %0d: Reset during operation", test_num);


        send_packet = 1;
        repeat(5) @(posedge clk);


        reset = 1;
        @(posedge clk);
        reset = 0;
        send_packet = 0;
        @(posedge clk);


        #1;



        check_outputs(4'd0, 4'd0, 4'd8);
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
        input [3:0] expected_acked_packets;
        input [3:0] expected_sent_packets;
        input [3:0] expected_window_size;
        begin
            if (expected_acked_packets === (expected_acked_packets ^ acked_packets ^ expected_acked_packets) &&
                expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: acked_packets=%h, sent_packets=%h, window_size=%h",
                         acked_packets, sent_packets, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_packets=%h, sent_packets=%h, window_size=%h",
                         expected_acked_packets, expected_sent_packets, expected_window_size);
                $display("  Got:      acked_packets=%h, sent_packets=%h, window_size=%h",
                         acked_packets, sent_packets, window_size);
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
        $dumpvars(0,ack_received, clk, reset, send_packet, acked_packets, sent_packets, window_size);
    end

endmodule

`timescale 1ns/1ps

module sliding_window_sender_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_packet;
    wire [3:0] sent_packets;
    wire [3:0] window;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_sender dut (
        .ack_received(ack_received),
        .clk(clk),
        .reset(reset),
        .send_packet(send_packet),
        .sent_packets(sent_packets),
        .window(window)
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
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: System Reset State Check", test_num);
        reset_dut();

        #1;


        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Sending Single Packet", test_num);
        reset_dut();
        @(posedge clk);
        send_packet = 1;
        @(posedge clk);
        send_packet = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(4'd1, 4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Send and ACK Single Packet", test_num);
        reset_dut();
        @(posedge clk);
        send_packet = 1;
        @(posedge clk);
        send_packet = 0;
        @(posedge clk);
        ack_received = 1;
        @(posedge clk);
        ack_received = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(4'd0, 4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Send Multiple Packets", test_num);
        reset_dut();
        @(posedge clk);
        send_packet = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        send_packet = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(4'd3, 4'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Interleaved Send and ACK", test_num);
        reset_dut();

        @(posedge clk);
        send_packet = 1;
        repeat(2) @(posedge clk);
        send_packet = 0;

        @(posedge clk);
        ack_received = 1;
        @(posedge clk);
        ack_received = 0;

        @(posedge clk);
        send_packet = 1;
        @(posedge clk);
        send_packet = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(4'd2, 4'd3);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = 6;
        $display("Testcase %0d: Filling Window Capacity", test_num);
        reset_dut();
        @(posedge clk);
        send_packet = 1;
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
        end
        send_packet = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(4'd8, 4'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Reset during operation", test_num);
        reset_dut();
        @(posedge clk);
        send_packet = 1;
        repeat(4) @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(4'd0, 4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_sender Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_sent_packets;
        input [3:0] expected_window;
        begin
            if (expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets) &&
                expected_window === (expected_window ^ window ^ expected_window)) begin
                $display("PASS");
                $display("  Outputs: sent_packets=%h, window=%h",
                         sent_packets, window);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sent_packets=%h, window=%h",
                         expected_sent_packets, expected_window);
                $display("  Got:      sent_packets=%h, window=%h",
                         sent_packets, window);
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
        $dumpvars(0,ack_received, clk, reset, send_packet, sent_packets, window);
    end

endmodule

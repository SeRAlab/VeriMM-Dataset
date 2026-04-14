`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send_packet;
    wire [3:0] acknowledged_packets;
    wire [3:0] receiver_window;
    wire [3:0] sender_window;
    wire [3:0] sent_packets;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send_packet(send_packet),
        .acknowledged_packets(acknowledged_packets),
        .receiver_window(receiver_window),
        .sender_window(sender_window),
        .sent_packets(sent_packets)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack = 0;
            send_packet = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd8, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Send Multiple Packets", test_num);
            reset_dut();
            @(posedge clk);
            send_packet = 1;
            repeat(3) @(posedge clk);
            send_packet = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd8, 4'd0, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Send and Acknowledge", test_num);
            reset_dut();
            @(posedge clk);
            send_packet = 1;
            repeat(2) @(posedge clk);
            send_packet = 0;
            ack = 1;
            @(posedge clk);
            @(posedge clk);
            ack = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd2, 4'd10, 4'd2, 4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Window Limit Enforcement", test_num);
            reset_dut();
            @(posedge clk);
            send_packet = 1;
            repeat(10) @(posedge clk);
            send_packet = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd8, 4'd0, 4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Sliding Window Cycle", test_num);
            reset_dut();

            @(posedge clk);
            send_packet = 1;
            repeat(8) @(posedge clk);
            send_packet = 0;

            ack = 1;
            repeat(4) @(posedge clk);
            ack = 0;

            send_packet = 1;
            repeat(2) @(posedge clk);
            send_packet = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd4, 4'd12, 4'd4, 4'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence Wrap-Around", test_num);
            reset_dut();

            @(posedge clk);
            send_packet = 1;
            ack = 1;
            repeat(12) @(posedge clk);
            send_packet = 0;
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(4'd12, 4'd4, 4'd12, 4'd12);
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
        input [3:0] expected_acknowledged_packets;
        input [3:0] expected_receiver_window;
        input [3:0] expected_sender_window;
        input [3:0] expected_sent_packets;
        begin
            if (expected_acknowledged_packets === (expected_acknowledged_packets ^ acknowledged_packets ^ expected_acknowledged_packets) &&
                expected_receiver_window === (expected_receiver_window ^ receiver_window ^ expected_receiver_window) &&
                expected_sender_window === (expected_sender_window ^ sender_window ^ expected_sender_window) &&
                expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets)) begin
                $display("PASS");
                $display("  Outputs: acknowledged_packets=%h, receiver_window=%h, sender_window=%h, sent_packets=%h",
                         acknowledged_packets, receiver_window, sender_window, sent_packets);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acknowledged_packets=%h, receiver_window=%h, sender_window=%h, sent_packets=%h",
                         expected_acknowledged_packets, expected_receiver_window, expected_sender_window, expected_sent_packets);
                $display("  Got:      acknowledged_packets=%h, receiver_window=%h, sender_window=%h, sent_packets=%h",
                         acknowledged_packets, receiver_window, sender_window, sent_packets);
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
        $dumpvars(0,ack, clk, rst, send_packet, acknowledged_packets, receiver_window, sender_window, sent_packets);
    end

endmodule

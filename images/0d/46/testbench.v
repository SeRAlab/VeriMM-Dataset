`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_packet;
    reg clk;
    reg reset;
    reg send_packet;
    wire [3:0] sent_packets;
    wire [3:0] window_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_packet(ack_packet),
        .clk(clk),
        .reset(reset),
        .send_packet(send_packet),
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
            ack_packet = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Packet Sent", test_num);
            reset_dut();
            send_packet = 1;
            @(posedge clk);
            #1;
            send_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple Packets Sent", test_num);
            reset_dut();
            send_packet = 1;
            repeat(3) @(posedge clk);
            #1;
            send_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd3, 4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Send and Acknowledge", test_num);
            reset_dut();

            send_packet = 1;
            repeat(2) @(posedge clk);
            #1;
            send_packet = 0;

            ack_packet = 1;
            @(posedge clk);
            #1;
            ack_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, 4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Clear All Packets", test_num);
            reset_dut();

            send_packet = 1;
            repeat(4) @(posedge clk);
            #1;
            send_packet = 0;

            ack_packet = 1;
            repeat(4) @(posedge clk);
            #1;
            ack_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Simultaneous Send and Ack", test_num);
            reset_dut();

            send_packet = 1;
            @(posedge clk);
            #1;

            send_packet = 1;
            ack_packet = 1;
            @(posedge clk);
            #1;
            send_packet = 0;
            ack_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, 4'd8);
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
        input [3:0] expected_sent_packets;
        input [3:0] expected_window_size;
        begin
            if (expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: sent_packets=%h, window_size=%h",
                         sent_packets, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sent_packets=%h, window_size=%h",
                         expected_sent_packets, expected_window_size);
                $display("  Got:      sent_packets=%h, window_size=%h",
                         sent_packets, window_size);
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
        $dumpvars(0,ack_packet, clk, reset, send_packet, sent_packets, window_size);
    end

endmodule

`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg rst;
    reg send_packet;
    wire [3:0] sent_packets;
    wire [1:0] window_end;
    wire [1:0] window_start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_received(ack_received),
        .clk(clk),
        .rst(rst),
        .send_packet(send_packet),
        .sent_packets(sent_packets),
        .window_end(window_end),
        .window_start(window_start)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send_packet = 0;
            ack_received = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase001: Reset State");

            #1;


            check_outputs(4'b0000, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase002: Send One Packet");
            send_packet = 1;
            @(posedge clk);
            #1;
            send_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0001, 2'b01, 2'b00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase003: Send Two, Ack One");

            send_packet = 1; @(posedge clk); #1;

            send_packet = 1; @(posedge clk); #1;
            send_packet = 0;

            ack_received = 1; @(posedge clk); #1;
            ack_received = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0010, 2'b10, 2'b01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase004: Fill Window");
            send_packet = 1;
            repeat(4) begin
                @(posedge clk); #1;
            end
            send_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1111, 2'b00, 2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase005: Slide Window (Fill 4, Ack 2, Send 1)");

            send_packet = 1;
            repeat(4) begin @(posedge clk); #1; end
            send_packet = 0;

            ack_received = 1;
            repeat(2) begin @(posedge clk); #1; end
            ack_received = 0;

            send_packet = 1;
            @(posedge clk); #1;
            send_packet = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'b1101, 2'b01, 2'b10);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running Testcase006: Full Clear");

            send_packet = 1;
            repeat(4) begin @(posedge clk); #1; end
            send_packet = 0;

            ack_received = 1;
            repeat(4) begin @(posedge clk); #1; end
            ack_received = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0000, 2'b00, 2'b00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Running Testcase007: Send Overflow (Send 5)");
            send_packet = 1;
            repeat(5) begin @(posedge clk); #1; end
            send_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1111, 2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Running Testcase008: Ack Underflow (Ack when empty)");
            ack_received = 1;
            @(posedge clk); #1;
            ack_received = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0000, 2'b00, 2'b00);
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
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_window_end;
        input [1:0] expected_window_start;
        begin
            if (expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets) &&
                expected_window_end === (expected_window_end ^ window_end ^ expected_window_end) &&
                expected_window_start === (expected_window_start ^ window_start ^ expected_window_start)) begin
                $display("PASS");
                $display("  Outputs: sent_packets=%h, window_end=%h, window_start=%h",
                         sent_packets, window_end, window_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sent_packets=%h, window_end=%h, window_start=%h",
                         expected_sent_packets, expected_window_end, expected_window_start);
                $display("  Got:      sent_packets=%h, window_end=%h, window_start=%h",
                         sent_packets, window_end, window_start);
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
        $dumpvars(0,ack_received, clk, rst, send_packet, sent_packets, window_end, window_start);
    end

endmodule

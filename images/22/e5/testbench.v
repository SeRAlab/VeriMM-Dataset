`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send_packet;
    wire [3:0] sent_packets;
    wire [3:0] window_end;
    wire [3:0] window_start;

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
            ack = 0;
            send_packet = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initialization Check");
            reset_dut();


            #1;



            check_outputs(4'd0, 4'd8, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Sending 3 packets");
            reset_dut();
            repeat(3) begin
                send_packet = 1;
                @(posedge clk);
                #1;
                send_packet = 0;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(4'd3, 4'd8, 4'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Filling the window (8 packets)");
            reset_dut();
            repeat(8) begin
                send_packet = 1;
                @(posedge clk);
                #1;
                send_packet = 0;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(4'd8, 4'd8, 4'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Window Overflow Protection");
            reset_dut();

            repeat(10) begin
                send_packet = 1;
                @(posedge clk);
                #1;
                send_packet = 0;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(4'd8, 4'd8, 4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: ACKing packets to slide window");
            reset_dut();

            repeat(5) begin
                send_packet = 1;
                @(posedge clk);
                #1;
                send_packet = 0;
                @(posedge clk);
                #1;
            end

            repeat(3) begin
                ack = 1;
                @(posedge clk);
                #1;
                ack = 0;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(4'd5, 4'd11, 4'd3);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Sequence Number Wrap-around");
            reset_dut();


            repeat(8) begin
                send_packet = 1; @(posedge clk); #1;
                send_packet = 0; @(posedge clk); #1;
            end

            repeat(8) begin
                ack = 1; @(posedge clk); #1;
                ack = 0; @(posedge clk); #1;
            end

            repeat(4) begin
                send_packet = 1; @(posedge clk); #1;
                send_packet = 0; @(posedge clk); #1;
            end

            #1;


            check_outputs(4'hC, 4'h0, 4'h8);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Interleaved Send and ACK");
            reset_dut();

            repeat(2) begin
                send_packet = 1; @(posedge clk); #1;
                send_packet = 0; @(posedge clk); #1;
            end
            ack = 1; @(posedge clk); #1;
            ack = 0; @(posedge clk); #1;
            repeat(2) begin
                send_packet = 1; @(posedge clk); #1;
                send_packet = 0; @(posedge clk); #1;
            end
            ack = 1; @(posedge clk); #1;
            ack = 0; @(posedge clk); #1;



            #1;




            check_outputs(4'd4, 4'hA, 4'd2);
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
        input [3:0] expected_window_end;
        input [3:0] expected_window_start;
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
        $dumpvars(0,ack, clk, rst, send_packet, sent_packets, window_end, window_start);
    end

endmodule

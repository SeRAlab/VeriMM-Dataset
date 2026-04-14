`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg rst;
    reg send_packet;
    wire [3:0] ack_num;
    wire [3:0] current_window_size;
    wire [3:0] next_seq_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .ack_received(ack_received),
        .clk(clk),
        .rst(rst),
        .send_packet(send_packet),
        .ack_num(ack_num),
        .current_window_size(current_window_size),
        .next_seq_num(next_seq_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack_received = 0;
            send_packet = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Packet Transmission");
            reset_dut();
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            @(posedge clk);

            #1;


            check_outputs(4'h0, 4'h1, 4'h1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Multiple Packet Transmissions");
            reset_dut();
            for (i = 0; i < 5; i = i + 1) begin
                send_packet = 1;
                @(posedge clk);
                send_packet = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(4'h0, 4'h5, 4'h5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Send and Receive ACK");
            reset_dut();

            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            @(posedge clk);

            ack_received = 1;
            @(posedge clk);
            ack_received = 0;
            @(posedge clk);

            #1;


            check_outputs(4'h1, 4'h0, 4'h1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Interleaved Send and ACK");
            reset_dut();

            repeat(3) begin
                send_packet = 1; @(posedge clk); send_packet = 0; @(posedge clk);
            end

            ack_received = 1; @(posedge clk); ack_received = 0; @(posedge clk);

            send_packet = 1; @(posedge clk); send_packet = 0; @(posedge clk);


            #1;



            check_outputs(4'h1, 4'h3, 4'h4);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Sequence Number Wrap Around (16 packets)");
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                send_packet = 1; @(posedge clk);
                send_packet = 0; @(posedge clk);
            end

            #1;


            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Simultaneous Send and ACK");
            reset_dut();

            repeat(2) begin
                send_packet = 1; @(posedge clk); send_packet = 0; @(posedge clk);
            end

            send_packet = 1;
            ack_received = 1;
            @(posedge clk);
            send_packet = 0;
            ack_received = 0;
            @(posedge clk);

            #1;


            check_outputs(4'h1, 4'h2, 4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_controller Testbench");
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
        input [3:0] expected_ack_num;
        input [3:0] expected_current_window_size;
        input [3:0] expected_next_seq_num;
        begin
            if (expected_ack_num === (expected_ack_num ^ ack_num ^ expected_ack_num) &&
                expected_current_window_size === (expected_current_window_size ^ current_window_size ^ expected_current_window_size) &&
                expected_next_seq_num === (expected_next_seq_num ^ next_seq_num ^ expected_next_seq_num)) begin
                $display("PASS");
                $display("  Outputs: ack_num=%h, current_window_size=%h, next_seq_num=%h",
                         ack_num, current_window_size, next_seq_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_num=%h, current_window_size=%h, next_seq_num=%h",
                         expected_ack_num, expected_current_window_size, expected_next_seq_num);
                $display("  Got:      ack_num=%h, current_window_size=%h, next_seq_num=%h",
                         ack_num, current_window_size, next_seq_num);
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
        $dumpvars(0,ack_received, clk, rst, send_packet, ack_num, current_window_size, next_seq_num);
    end

endmodule

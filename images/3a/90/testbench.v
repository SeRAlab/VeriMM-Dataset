`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_packet;
    wire [2:0] ack_seq_num;
    wire [2:0] sent_seq_num;
    wire window_full;

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
        .ack_seq_num(ack_seq_num),
        .sent_seq_num(sent_seq_num),
        .window_full(window_full)
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
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(3'd0, 3'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            #10;

            #1;


            check_outputs(3'd0, 3'd1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                send_packet = 1;
                @(posedge clk);
                send_packet = 0;
            end
            #10;

            #1;


            check_outputs(3'd0, 3'd4, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();

            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                send_packet = 1;
                @(posedge clk);
                send_packet = 0;
            end

            @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;
            #10;

            #1;


            check_outputs(3'd1, 3'd4, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();

            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
                send_packet = 1;
                ack_received = 1;
                @(posedge clk);
                send_packet = 0;
                ack_received = 0;
            end

            @(posedge clk);
            send_packet = 1;
            ack_received = 1;
            @(posedge clk);
            send_packet = 0;
            ack_received = 0;
            #10;

            #1;


            check_outputs(3'd0, 3'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            repeat(2) begin
                @(posedge clk);
                send_packet = 1;
                @(posedge clk);
                send_packet = 0;
            end

            repeat(2) begin
                @(posedge clk);
                ack_received = 1;
                @(posedge clk);
                ack_received = 0;
            end
            #10;

            #1;


            check_outputs(3'd2, 3'd2, 1'b0);
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
        input [2:0] expected_ack_seq_num;
        input [2:0] expected_sent_seq_num;
        input expected_window_full;
        begin
            if (expected_ack_seq_num === (expected_ack_seq_num ^ ack_seq_num ^ expected_ack_seq_num) &&
                expected_sent_seq_num === (expected_sent_seq_num ^ sent_seq_num ^ expected_sent_seq_num) &&
                expected_window_full === (expected_window_full ^ window_full ^ expected_window_full)) begin
                $display("PASS");
                $display("  Outputs: ack_seq_num=%h, sent_seq_num=%h, window_full=%b",
                         ack_seq_num, sent_seq_num, window_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_seq_num=%h, sent_seq_num=%h, window_full=%b",
                         expected_ack_seq_num, expected_sent_seq_num, expected_window_full);
                $display("  Got:      ack_seq_num=%h, sent_seq_num=%h, window_full=%b",
                         ack_seq_num, sent_seq_num, window_full);
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
        $dumpvars(0,ack_received, clk, reset, send_packet, ack_seq_num, sent_seq_num, window_full);
    end

endmodule

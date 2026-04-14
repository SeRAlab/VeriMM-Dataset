`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    wire [3:0] acked_frames;
    wire [3:0] sent_frames;
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
        .acked_frames(acked_frames),
        .sent_frames(sent_frames),
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
            #20;
            rst = 0;
            #20;
        end
        endtask
    task pulse_send;

        begin
            send = 1;
            @(posedge clk);
            #1;
            send = 0;
            @(posedge clk);
            #1;
        end
        endtask

    task pulse_ack;

        begin
            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Single Frame Send", test_num);
            reset_dut();
            pulse_send();
            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd1, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Send and ACK", test_num);
            reset_dut();
            pulse_send();
            pulse_ack();
            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd1, 4'd8);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Running Testcase %0d: Fill Window (8 Frames)", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                pulse_send();
            end
            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd8, 4'd8);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Running Testcase %0d: Prevent Transmission Beyond Window", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                pulse_send();
            end

            pulse_send();
            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd8, 4'd8);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Running Testcase %0d: Sliding Window Operation", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) pulse_send();

            repeat(3) pulse_ack();

            repeat(2) pulse_send();

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'd3, 4'd10, 4'd8);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Running Testcase %0d: Multi-ACK Burst", test_num);
            reset_dut();

            for (i = 0; i < 4; i = i + 1) pulse_send();

            for (i = 0; i < 4; i = i + 1) pulse_ack();

            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd4, 4'd4, 4'd8);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("Running Testcase %0d: Counter Wrap Around", test_num);
            reset_dut();


            repeat(8) pulse_send();
            repeat(8) pulse_ack();
            repeat(8) pulse_send();
            repeat(7) pulse_ack();

            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd15, 4'd0, 4'd8);
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
        input [3:0] expected_acked_frames;
        input [3:0] expected_sent_frames;
        input [3:0] expected_window_size;
        begin
            if (expected_acked_frames === (expected_acked_frames ^ acked_frames ^ expected_acked_frames) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: acked_frames=%h, sent_frames=%h, window_size=%h",
                         acked_frames, sent_frames, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_frames=%h, sent_frames=%h, window_size=%h",
                         expected_acked_frames, expected_sent_frames, expected_window_size);
                $display("  Got:      acked_frames=%h, sent_frames=%h, window_size=%h",
                         acked_frames, sent_frames, window_size);
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
        $dumpvars(0,ack, clk, rst, send, acked_frames, sent_frames, window_size);
    end

endmodule

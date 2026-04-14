`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_frame;
    wire [3:0] acked_frames;
    wire [3:0] sent_frames;
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
        .reset(reset),
        .send_frame(send_frame),
        .acked_frames(acked_frames),
        .sent_frames(sent_frames),
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
            reset = 1;
            ack = 0;
            send_frame = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 4'h4, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Send Single Frame");
            reset_dut();
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h1, 4'h4, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Fill Window (4 frames)");
            reset_dut();
            repeat(4) begin
                send_frame = 1;
                @(posedge clk);
            end
            send_frame = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h4, 4'h4, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Overflow Prevention");
            reset_dut();
            repeat(6) begin
                send_frame = 1;
                @(posedge clk);
            end
            send_frame = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h4, 4'h4, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Sliding Window (Send 4, Ack 2, Send 2)");
            reset_dut();

            repeat(4) begin send_frame = 1; @(posedge clk); end
            send_frame = 0;

            repeat(2) begin ack = 1; @(posedge clk); end
            ack = 0;

            repeat(2) begin send_frame = 1; @(posedge clk); end
            send_frame = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h2, 4'h6, 4'h6, 4'h2);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Wrap-around Sequence Numbers");
            reset_dut();


            repeat(14) begin
                send_frame = 1;
                ack = 1;
                @(posedge clk);
            end
            send_frame = 0;
            ack = 0;
            @(posedge clk);


            repeat(2) begin
                send_frame = 1;
                @(posedge clk);
            end
            send_frame = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'd14, 4'd0, 4'd2, 4'd14);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Full window wrap-around blocking");
            reset_dut();

            repeat(14) begin
                send_frame = 1;
                ack = 1;
                @(posedge clk);
            end
            send_frame = 0;
            ack = 0;



            repeat(6) begin
                send_frame = 1;
                @(posedge clk);
            end
            send_frame = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd14, 4'd2, 4'd2, 4'd14);
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
        input [3:0] expected_acked_frames;
        input [3:0] expected_sent_frames;
        input [3:0] expected_window_end;
        input [3:0] expected_window_start;
        begin
            if (expected_acked_frames === (expected_acked_frames ^ acked_frames ^ expected_acked_frames) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames) &&
                expected_window_end === (expected_window_end ^ window_end ^ expected_window_end) &&
                expected_window_start === (expected_window_start ^ window_start ^ expected_window_start)) begin
                $display("PASS");
                $display("  Outputs: acked_frames=%h, sent_frames=%h, window_end=%h, window_start=%h",
                         acked_frames, sent_frames, window_end, window_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_frames=%h, sent_frames=%h, window_end=%h, window_start=%h",
                         expected_acked_frames, expected_sent_frames, expected_window_end, expected_window_start);
                $display("  Got:      acked_frames=%h, sent_frames=%h, window_end=%h, window_start=%h",
                         acked_frames, sent_frames, window_end, window_start);
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
        $dumpvars(0,ack, clk, reset, send_frame, acked_frames, sent_frames, window_end, window_start);
    end

endmodule

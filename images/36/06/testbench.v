`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    wire [3:0] ack_frames;
    wire [3:0] sent_frames;

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
        .ack_frames(ack_frames),
        .sent_frames(sent_frames)
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
            #10;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset");
            reset_dut();
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Frame Send");
            reset_dut();
            send = 1;
            @(posedge clk);
            #1 send = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Send and Acknowledge");
            reset_dut();

            send = 1;
            @(posedge clk);
            #1 send = 0;

            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple Frames Within Window");
            reset_dut();
            send = 1;
            repeat(3) @(posedge clk);
            #1 send = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Interleaved Send and ACK");
            reset_dut();

            send = 1;
            repeat(2) @(posedge clk);
            #1 send = 0;

            ack = 1;
            @(posedge clk);
            #1 ack = 0;

            send = 1;
            @(posedge clk);
            #1 send = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd3);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: ACK without Send");
            reset_dut();
            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Testcase 007: Max Window Stress Test");
            reset_dut();
            send = 1;


            repeat(10) @(posedge clk);
            #1 send = 0;
            ack = 1;
            repeat(2) @(posedge clk);
            #1 ack = 0;
            @(posedge clk);



            if (ack_frames == 4'd2 && sent_frames >= 4'd2) begin
                pass_count = pass_count + 1;
                $display("PASS: Logic handled window and ACKs");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Logic error in window/ACK tracking");
            end
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
        input [3:0] expected_ack_frames;
        input [3:0] expected_sent_frames;
        begin
            if (expected_ack_frames === (expected_ack_frames ^ ack_frames ^ expected_ack_frames) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames)) begin
                $display("PASS");
                $display("  Outputs: ack_frames=%h, sent_frames=%h",
                         ack_frames, sent_frames);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_frames=%h, sent_frames=%h",
                         expected_ack_frames, expected_sent_frames);
                $display("  Got:      ack_frames=%h, sent_frames=%h",
                         ack_frames, sent_frames);
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
        $dumpvars(0,ack, clk, rst, send, ack_frames, sent_frames);
    end

endmodule

`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg send;
    wire [3:0] ack_frame;
    wire all_sent;
    wire [3:0] sent_frame;
    wire window_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .clk(clk),
        .reset(reset),
        .send(send),
        .ack_frame(ack_frame),
        .all_sent(all_sent),
        .sent_frame(sent_frame),
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
            send = 0;
            test_num = test_num + 1;
            $display("--- Testcase %03d ---", test_num);
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset State");
            reset_dut();

            #1;


            check_outputs(4'd0, 1'b0, 4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Sending Single Frame");
            reset_dut();
            @(posedge clk);
            #1;
            send = 1;
            @(posedge clk);
            #1;
            send = 0;


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b0, 4'd1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Sending Multiple Frames (3 Frames)");
            reset_dut();
            for (i = 0; i < 3; i = i + 1) begin
                @(posedge clk);
                #1;
                send = 1;
                @(posedge clk);
                #1;
                send = 0;

                wait(ack_frame == (i + 1));
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(4'd3, 1'b0, 4'd3, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Complete Protocol Cycle (All Frames)");
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
                send = 1;
                @(posedge clk);
                #1;
                send = 0;
                wait(ack_frame == (i + 1));
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(4'd8, 1'b1, 4'd8, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking Window Full Condition");
            reset_dut();
            @(posedge clk);
            #1;


            repeat(4) begin
                send = 1;
                @(posedge clk);
                #1;
            end
            send = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 1'b0, 4'd4, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset Mid-transmission");
            reset_dut();
            @(posedge clk);
            #1;
            send = 1;
            repeat(2) @(posedge clk);
            #1;
            send = 0;

            reset = 1;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 1'b0, 4'd0, 1'b0);
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
        input [3:0] expected_ack_frame;
        input expected_all_sent;
        input [3:0] expected_sent_frame;
        input expected_window_full;
        begin
            if (expected_ack_frame === (expected_ack_frame ^ ack_frame ^ expected_ack_frame) &&
                expected_all_sent === (expected_all_sent ^ all_sent ^ expected_all_sent) &&
                expected_sent_frame === (expected_sent_frame ^ sent_frame ^ expected_sent_frame) &&
                expected_window_full === (expected_window_full ^ window_full ^ expected_window_full)) begin
                $display("PASS");
                $display("  Outputs: ack_frame=%h, all_sent=%b, sent_frame=%h, window_full=%b",
                         ack_frame, all_sent, sent_frame, window_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_frame=%h, all_sent=%b, sent_frame=%h, window_full=%b",
                         expected_ack_frame, expected_all_sent, expected_sent_frame, expected_window_full);
                $display("  Got:      ack_frame=%h, all_sent=%b, sent_frame=%h, window_full=%b",
                         ack_frame, all_sent, sent_frame, window_full);
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
        $dumpvars(0,clk, reset, send, ack_frame, all_sent, sent_frame, window_full);
    end

endmodule

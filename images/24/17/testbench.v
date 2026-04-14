`timescale 1ns/1ps

module SlidingWindowProtocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg [3:0] frame_number;
    reg reset;
    reg send_frame;
    wire [3:0] acked_frame;
    wire is_window_full;
    wire [3:0] sent_frame;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SlidingWindowProtocol dut (
        .ack_received(ack_received),
        .clk(clk),
        .frame_number(frame_number),
        .reset(reset),
        .send_frame(send_frame),
        .acked_frame(acked_frame),
        .is_window_full(is_window_full),
        .sent_frame(sent_frame)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send_frame = 0;
            ack_received = 0;
            frame_number = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Transmission...");
            reset_dut();


            send_frame = 1;
            frame_number = 4'h1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);


            ack_received = 1;
            frame_number = 4'h1;
            @(posedge clk);
            ack_received = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h1, 1'b0, 4'h1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Fill Window...");
            reset_dut();


            send_frame = 1;
            frame_number = 4'h0; @(posedge clk);
            frame_number = 4'h1; @(posedge clk);
            frame_number = 4'h2; @(posedge clk);
            frame_number = 4'h3; @(posedge clk);
            send_frame = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h0, 1'b1, 4'h3);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sliding Window...");
            reset_dut();


            send_frame = 1;
            frame_number = 4'h0; @(posedge clk);
            frame_number = 4'h1; @(posedge clk);
            frame_number = 4'h2; @(posedge clk);
            frame_number = 4'h3; @(posedge clk);
            send_frame = 0;
            @(posedge clk);


            ack_received = 1;
            frame_number = 4'h0;
            @(posedge clk);
            ack_received = 0;
            @(posedge clk);


            send_frame = 1;
            frame_number = 4'h4;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h0, 1'b1, 4'h4);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Sequential ACKs...");
            reset_dut();


            send_frame = 1;
            frame_number = 4'h5; @(posedge clk);
            frame_number = 4'h6; @(posedge clk);
            send_frame = 0;
            @(posedge clk);


            ack_received = 1;
            frame_number = 4'h5; @(posedge clk);
            frame_number = 4'h6; @(posedge clk);
            ack_received = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h6, 1'b0, 4'h6);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset mid-transmission...");
            reset_dut();

            send_frame = 1;
            frame_number = 4'hA; @(posedge clk);
            frame_number = 4'hB; @(posedge clk);
            send_frame = 0;


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h0, 1'b0, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SlidingWindowProtocol Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_acked_frame;
        input expected_is_window_full;
        input [3:0] expected_sent_frame;
        begin
            if (expected_acked_frame === (expected_acked_frame ^ acked_frame ^ expected_acked_frame) &&
                expected_is_window_full === (expected_is_window_full ^ is_window_full ^ expected_is_window_full) &&
                expected_sent_frame === (expected_sent_frame ^ sent_frame ^ expected_sent_frame)) begin
                $display("PASS");
                $display("  Outputs: acked_frame=%h, is_window_full=%b, sent_frame=%h",
                         acked_frame, is_window_full, sent_frame);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_frame=%h, is_window_full=%b, sent_frame=%h",
                         expected_acked_frame, expected_is_window_full, expected_sent_frame);
                $display("  Got:      acked_frame=%h, is_window_full=%b, sent_frame=%h",
                         acked_frame, is_window_full, sent_frame);
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
        $dumpvars(0,ack_received, clk, frame_number, reset, send_frame, acked_frame, is_window_full, sent_frame);
    end

endmodule

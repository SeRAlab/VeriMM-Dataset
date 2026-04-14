`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg rst;
    reg send_frame;
    wire [1:0] current_state;
    wire [3:0] frames_sent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .ack_received(ack_received),
        .clk(clk),
        .rst(rst),
        .send_frame(send_frame),
        .current_state(current_state),
        .frames_sent(frames_sent)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send_frame = 0;
            ack_received = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Power-on Reset");
            reset_dut();

            #1;


            check_outputs(STATE_IDLE, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Send Single Frame");
            reset_dut();
            send_frame = 1;
            @(posedge clk);
            #1;

            if (current_state !== STATE_SENDING) $display("Note: Transition to SENDING state not seen immediately");

            send_frame = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(STATE_IDLE, 4'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Fill Window (4 frames)");
            reset_dut();
            repeat(4) begin
                send_frame = 1;
                @(posedge clk);
                #1;
                send_frame = 0;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(STATE_WAITING, 4'd4);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Receive ACK after Full Window");
            reset_dut();

            repeat(4) begin
                send_frame = 1; @(posedge clk); #1;
                send_frame = 0; @(posedge clk); #1;
            end

            ack_received = 1;
            @(posedge clk);
            #1;
            ack_received = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(STATE_IDLE, 4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Window Overflow Protection");
            reset_dut();

            repeat(6) begin
                send_frame = 1;
                @(posedge clk);
                #1;
                send_frame = 0;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(STATE_WAITING, 4'd4);
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
        input [1:0] expected_current_state;
        input [3:0] expected_frames_sent;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state) &&
                expected_frames_sent === (expected_frames_sent ^ frames_sent ^ expected_frames_sent)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h, frames_sent=%h",
                         current_state, frames_sent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h, frames_sent=%h",
                         expected_current_state, expected_frames_sent);
                $display("  Got:      current_state=%h, frames_sent=%h",
                         current_state, frames_sent);
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
        $dumpvars(0,ack_received, clk, rst, send_frame, current_state, frames_sent);
    end

endmodule

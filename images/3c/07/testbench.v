`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_frame;
    reg clk;
    reg reset;
    reg send_frame;
    wire [3:0] acked_frames;
    wire [3:0] sent_frames;
    wire window_empty;
    wire window_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_frame(ack_frame),
        .clk(clk),
        .reset(reset),
        .send_frame(send_frame),
        .acked_frames(acked_frames),
        .sent_frames(sent_frames),
        .window_empty(window_empty),
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
            send_frame = 0;
            ack_frame = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Send Single Frame", test_num);
            reset_dut();

            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;


            #1;



            check_outputs(4'd0, 4'd1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Fill Window", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;


            #1;



            check_outputs(4'd0, 4'd8, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Fill and Acknowledge All", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                ack_frame = 1;
            end
            @(posedge clk);
            ack_frame = 0;


            #1;



            check_outputs(4'd8, 4'd8, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Partial Acknowledge", test_num);
            reset_dut();


            for (i = 0; i < 6; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;


            for (i = 0; i < 3; i = i + 1) begin
                @(posedge clk);
                ack_frame = 1;
            end
            @(posedge clk);
            ack_frame = 0;


            #1;



            check_outputs(4'd3, 4'd6, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("\nTestcase %0d: Overflow Prevention", test_num);
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;


            #1;



            check_outputs(4'd0, 4'd8, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("\nTestcase %0d: Sequence Number Wrapping", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin @(posedge clk) send_frame = 1; end
            @(posedge clk) send_frame = 0;
            for (i = 0; i < 8; i = i + 1) begin @(posedge clk) ack_frame = 1; end
            @(posedge clk) ack_frame = 0;


            for (i = 0; i < 8; i = i + 1) begin @(posedge clk) send_frame = 1; end
            @(posedge clk) send_frame = 0;


            #1;



            check_outputs(4'd8, 4'd0, 1'b0, 1'b1);
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
        input expected_window_empty;
        input expected_window_full;
        begin
            if (expected_acked_frames === (expected_acked_frames ^ acked_frames ^ expected_acked_frames) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames) &&
                expected_window_empty === (expected_window_empty ^ window_empty ^ expected_window_empty) &&
                expected_window_full === (expected_window_full ^ window_full ^ expected_window_full)) begin
                $display("PASS");
                $display("  Outputs: acked_frames=%h, sent_frames=%h, window_empty=%b, window_full=%b",
                         acked_frames, sent_frames, window_empty, window_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_frames=%h, sent_frames=%h, window_empty=%b, window_full=%b",
                         expected_acked_frames, expected_sent_frames, expected_window_empty, expected_window_full);
                $display("  Got:      acked_frames=%h, sent_frames=%h, window_empty=%b, window_full=%b",
                         acked_frames, sent_frames, window_empty, window_full);
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
        $dumpvars(0,ack_frame, clk, reset, send_frame, acked_frames, sent_frames, window_empty, window_full);
    end

endmodule

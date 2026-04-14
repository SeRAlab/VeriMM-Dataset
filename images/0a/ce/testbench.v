`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_frame;
    wire [3:0] ack_count;
    wire ready_to_send;
    wire [3:0] sent_count;
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
        .send_frame(send_frame),
        .ack_count(ack_count),
        .ready_to_send(ready_to_send),
        .sent_count(sent_count),
        .window_full(window_full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            send_frame = 0;
            ack_received = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Send single frame...");
            reset_dut();
            test_num = 1;


            send_frame = 1;
            @(posedge clk);
            #1;
            send_frame = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'd0, 1'b1, 4'd1, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("\nRunning testcase002: Fill the window (4 frames)...");
            reset_dut();
            test_num = 2;


            for (i = 0; i < 4; i = i + 1) begin
                send_frame = 1;
                @(posedge clk);
                #1;
                send_frame = 0;
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(4'd0, 1'b0, 4'd4, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Try to exceed window limit...");
            reset_dut();
            test_num = 3;


            for (i = 0; i < 5; i = i + 1) begin
                send_frame = 1;
                @(posedge clk);
                #1;
                send_frame = 0;
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(4'd0, 1'b0, 4'd4, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nRunning testcase004: Receive ACK after full window...");
            reset_dut();
            test_num = 4;


            for (i = 0; i < 4; i = i + 1) begin
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



            check_outputs(4'd1, 1'b1, 4'd4, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("\nRunning testcase005: Full cycle transmission...");
            reset_dut();
            test_num = 5;


            for (i = 0; i < 4; i = i + 1) begin
                send_frame = 1; @(posedge clk); #1;
                send_frame = 0; @(posedge clk); #1;
            end


            for (i = 0; i < 4; i = i + 1) begin
                ack_received = 1; @(posedge clk); #1;
                ack_received = 0; @(posedge clk); #1;
            end


            for (i = 0; i < 2; i = i + 1) begin
                send_frame = 1; @(posedge clk); #1;
                send_frame = 0; @(posedge clk); #1;
            end


            #1;



            check_outputs(4'd4, 1'b1, 4'd6, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Interleaved Send and ACK...");
            reset_dut();
            test_num = 6;


            send_frame = 1; @(posedge clk); #1;
            send_frame = 1; @(posedge clk); #1;
            send_frame = 0;


            ack_received = 1; @(posedge clk); #1;
            ack_received = 0; @(posedge clk); #1;


            send_frame = 1; @(posedge clk); #1;
            send_frame = 1; @(posedge clk); #1;
            send_frame = 0;


            #1;



            check_outputs(4'd1, 1'b1, 4'd4, 1'b0);
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
        input [3:0] expected_ack_count;
        input expected_ready_to_send;
        input [3:0] expected_sent_count;
        input expected_window_full;
        begin
            if (expected_ack_count === (expected_ack_count ^ ack_count ^ expected_ack_count) &&
                expected_ready_to_send === (expected_ready_to_send ^ ready_to_send ^ expected_ready_to_send) &&
                expected_sent_count === (expected_sent_count ^ sent_count ^ expected_sent_count) &&
                expected_window_full === (expected_window_full ^ window_full ^ expected_window_full)) begin
                $display("PASS");
                $display("  Outputs: ack_count=%h, ready_to_send=%b, sent_count=%h, window_full=%b",
                         ack_count, ready_to_send, sent_count, window_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_count=%h, ready_to_send=%b, sent_count=%h, window_full=%b",
                         expected_ack_count, expected_ready_to_send, expected_sent_count, expected_window_full);
                $display("  Got:      ack_count=%h, ready_to_send=%b, sent_count=%h, window_full=%b",
                         ack_count, ready_to_send, sent_count, window_full);
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
        $dumpvars(0,ack_received, clk, reset, send_frame, ack_count, ready_to_send, sent_count, window_full);
    end

endmodule

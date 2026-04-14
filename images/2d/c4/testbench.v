`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_frame;
    wire [3:0] acked_frames;
    wire [3:0] sent_frames;

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
        .acked_frames(acked_frames),
        .sent_frames(sent_frames)
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
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Send/Ack...");
            reset_dut();

            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;

            repeat(2) @(posedge clk);

            ack_received = 1;
            @(posedge clk);
            ack_received = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'd1, 4'd1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Running testcase002: Fill Window...");
            reset_dut();

            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                send_frame = 0;
            end

            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'd0, 4'd4);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Window Limit Check...");
            reset_dut();


            for (i = 0; i < 6; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                send_frame = 0;
            end

            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'd0, 4'd4);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Sliding Window Logic...");
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                send_frame = 0;
            end


            repeat(2) begin
                @(posedge clk);
                ack_received = 1;
                @(posedge clk);
                ack_received = 0;
            end


            for (i = 0; i < 2; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                send_frame = 0;
            end

            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'd2, 4'd6);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Continuous Operation...");
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                send_frame = 0;

                @(posedge clk);
                ack_received = 1;
                @(posedge clk);
                ack_received = 0;
            end

            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'hA, 4'hA);
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
        begin
            if (expected_acked_frames === (expected_acked_frames ^ acked_frames ^ expected_acked_frames) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames)) begin
                $display("PASS");
                $display("  Outputs: acked_frames=%h, sent_frames=%h",
                         acked_frames, sent_frames);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_frames=%h, sent_frames=%h",
                         expected_acked_frames, expected_sent_frames);
                $display("  Got:      acked_frames=%h, sent_frames=%h",
                         acked_frames, sent_frames);
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
        $dumpvars(0,ack_received, clk, reset, send_frame, acked_frames, sent_frames);
    end

endmodule

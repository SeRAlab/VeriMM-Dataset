`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_frame;
    reg clk;
    reg reset;
    reg send_frame;
    wire [2:0] acked_frames;
    wire [2:0] current_window_size;
    wire [2:0] sent_frames;

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
        .current_window_size(current_window_size),
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
            ack_frame = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initialization Check", test_num);
            reset_dut();

            #1;


            check_outputs(3'd0, 3'd0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Send Single Frame", test_num);
            reset_dut();
            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            #1 send_frame = 0;
            @(posedge clk);

            #1;


            check_outputs(3'd0, 3'd1, 3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Send Multiple Frames", test_num);
            reset_dut();
            repeat (3) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                #1 send_frame = 0;
            end
            @(posedge clk);

            #1;


            check_outputs(3'd0, 3'd3, 3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill Window and Block", test_num);
            reset_dut();
            repeat (6) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                #1 send_frame = 0;
            end
            @(posedge clk);

            #1;


            check_outputs(3'd0, 3'd4, 3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Acknowledge Sent Frames", test_num);
            reset_dut();

            repeat (3) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                #1 send_frame = 0;
            end

            repeat (2) begin
                @(posedge clk);
                ack_frame = 1;
                @(posedge clk);
                #1 ack_frame = 0;
            end
            @(posedge clk);

            #1;


            check_outputs(3'd2, 3'd1, 3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sliding the Window", test_num);
            reset_dut();

            repeat (4) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                #1 send_frame = 0;
            end

            repeat (2) begin
                @(posedge clk);
                ack_frame = 1;
                @(posedge clk);
                #1 ack_frame = 0;
            end

            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            #1 send_frame = 0;

            @(posedge clk);

            #1;


            check_outputs(3'd2, 3'd3, 3'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence Wraparound", test_num);
            reset_dut();

            repeat (4) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                #1 send_frame = 0;
            end
            repeat (4) begin
                @(posedge clk);
                ack_frame = 1;
                @(posedge clk);
                #1 ack_frame = 0;
            end
            repeat (4) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                #1 send_frame = 0;
            end
            @(posedge clk);


            #1;



            check_outputs(3'd4, 3'd4, 3'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Send and Ack", test_num);
            reset_dut();

            repeat (2) begin
                @(posedge clk);
                send_frame = 1;
                @(posedge clk);
                #1 send_frame = 0;
            end

            @(posedge clk);
            send_frame = 1;
            ack_frame = 1;
            @(posedge clk);
            #1;
            send_frame = 0;
            ack_frame = 0;
            @(posedge clk);

            #1;


            check_outputs(3'd1, 3'd2, 3'd3);
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
        input [2:0] expected_acked_frames;
        input [2:0] expected_current_window_size;
        input [2:0] expected_sent_frames;
        begin
            if (expected_acked_frames === (expected_acked_frames ^ acked_frames ^ expected_acked_frames) &&
                expected_current_window_size === (expected_current_window_size ^ current_window_size ^ expected_current_window_size) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames)) begin
                $display("PASS");
                $display("  Outputs: acked_frames=%h, current_window_size=%h, sent_frames=%h",
                         acked_frames, current_window_size, sent_frames);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_frames=%h, current_window_size=%h, sent_frames=%h",
                         expected_acked_frames, expected_current_window_size, expected_sent_frames);
                $display("  Got:      acked_frames=%h, current_window_size=%h, sent_frames=%h",
                         acked_frames, current_window_size, sent_frames);
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
        $dumpvars(0,ack_frame, clk, reset, send_frame, acked_frames, current_window_size, sent_frames);
    end

endmodule

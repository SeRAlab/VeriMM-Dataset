`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send_req;
    wire [3:0] acked_frames;
    wire [3:0] sent_frames;
    wire [3:0] window;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send_req(send_req),
        .acked_frames(acked_frames),
        .sent_frames(sent_frames),
        .window(window)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send_req = 0;
            ack = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Sending 3 frames", test_num);
            reset_dut();
            repeat(3) begin
                send_req = 1;
                @(posedge clk);
                #1;
            end
            send_req = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd3, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Filling the window (4 frames)", test_num);
            reset_dut();
            repeat(4) begin
                send_req = 1;
                @(posedge clk);
                #1;
            end
            send_req = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd4, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Overflow prevention (Try to send 6 frames)", test_num);
            reset_dut();
            repeat(6) begin
                send_req = 1;
                @(posedge clk);
                #1;
            end
            send_req = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd4, 4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Send 4, Acknowledge 2", test_num);
            reset_dut();
            repeat(4) begin
                send_req = 1; @(posedge clk); #1;
            end
            send_req = 0;
            repeat(2) begin
                ack = 1; @(posedge clk); #1;
            end
            ack = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd2, 4'd4, 4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Send 4, Acknowledge 4", test_num);
            reset_dut();
            repeat(4) begin
                send_req = 1; @(posedge clk); #1;
            end
            send_req = 0;
            repeat(4) begin
                ack = 1; @(posedge clk); #1;
            end
            ack = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd4, 4'd4, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Sliding Window (Send 4, Ack 2, Send 2 more)", test_num);
            reset_dut();

            repeat(4) begin
                send_req = 1; @(posedge clk); #1;
            end
            send_req = 0;

            repeat(2) begin
                ack = 1; @(posedge clk); #1;
            end
            ack = 0;

            repeat(2) begin
                send_req = 1; @(posedge clk); #1;
            end
            send_req = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd2, 4'd6, 4'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Simultaneous Send and Ack", test_num);
            reset_dut();

            send_req = 1; @(posedge clk); #1;
            send_req = 0;

            send_req = 1;
            ack = 1;
            @(posedge clk);
            #1;
            send_req = 0;
            ack = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd1, 4'd2, 4'd1);
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
        input [3:0] expected_window;
        begin
            if (expected_acked_frames === (expected_acked_frames ^ acked_frames ^ expected_acked_frames) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames) &&
                expected_window === (expected_window ^ window ^ expected_window)) begin
                $display("PASS");
                $display("  Outputs: acked_frames=%h, sent_frames=%h, window=%h",
                         acked_frames, sent_frames, window);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_frames=%h, sent_frames=%h, window=%h",
                         expected_acked_frames, expected_sent_frames, expected_window);
                $display("  Got:      acked_frames=%h, sent_frames=%h, window=%h",
                         acked_frames, sent_frames, window);
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
        $dumpvars(0,ack, clk, rst, send_req, acked_frames, sent_frames, window);
    end

endmodule

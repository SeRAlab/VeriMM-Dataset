`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg recv_ack;
    reg reset;
    reg send_frame;
    wire [3:0] frames_acknowledged;
    wire [3:0] frames_sent;
    wire window_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .clk(clk),
        .recv_ack(recv_ack),
        .reset(reset),
        .send_frame(send_frame),
        .frames_acknowledged(frames_acknowledged),
        .frames_sent(frames_sent),
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
            recv_ack = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Send 3 Frames", test_num);
            reset_dut();
            repeat (3) begin
                send_frame = 1;
                @(negedge clk);
            end
            send_frame = 0;
            @(negedge clk);

            #1;


            check_outputs(4'h0, 4'h3, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fill Window (4 frames)", test_num);
            reset_dut();
            repeat (4) begin
                send_frame = 1;
                @(negedge clk);
            end
            send_frame = 0;
            @(negedge clk);

            #1;


            check_outputs(4'h0, 4'h4, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Slide Window (Full, Ack 2, Send 1)", test_num);
            reset_dut();

            repeat (4) begin
                send_frame = 1;
                @(negedge clk);
            end
            send_frame = 0;

            repeat (2) begin
                recv_ack = 1;
                @(negedge clk);
            end
            recv_ack = 0;

            send_frame = 1;
            @(negedge clk);
            send_frame = 0;
            @(negedge clk);

            #1;


            check_outputs(4'h2, 4'h5, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Attempt Send When Full", test_num);
            reset_dut();

            repeat (6) begin
                send_frame = 1;
                @(negedge clk);
            end
            send_frame = 0;
            @(negedge clk);

            #1;


            check_outputs(4'h0, 4'h4, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Counter Wrap-around", test_num);
            reset_dut();

            repeat (14) begin
                send_frame = 1;
                @(negedge clk);
                send_frame = 0;
                recv_ack = 1;
                @(negedge clk);
                recv_ack = 0;
            end


            repeat (3) begin
                send_frame = 1;
                @(negedge clk);
            end
            send_frame = 0;
            @(negedge clk);



            #1;




            check_outputs(4'hE, 4'h1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiple ACKs burst", test_num);
            reset_dut();

            repeat (4) begin
                send_frame = 1;
                @(negedge clk);
            end
            send_frame = 0;

            repeat (4) begin
                recv_ack = 1;
                @(negedge clk);
            end
            recv_ack = 0;
            @(negedge clk);

            #1;


            check_outputs(4'h4, 4'h4, 1'b0);
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
        input [3:0] expected_frames_acknowledged;
        input [3:0] expected_frames_sent;
        input expected_window_full;
        begin
            if (expected_frames_acknowledged === (expected_frames_acknowledged ^ frames_acknowledged ^ expected_frames_acknowledged) &&
                expected_frames_sent === (expected_frames_sent ^ frames_sent ^ expected_frames_sent) &&
                expected_window_full === (expected_window_full ^ window_full ^ expected_window_full)) begin
                $display("PASS");
                $display("  Outputs: frames_acknowledged=%h, frames_sent=%h, window_full=%b",
                         frames_acknowledged, frames_sent, window_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frames_acknowledged=%h, frames_sent=%h, window_full=%b",
                         expected_frames_acknowledged, expected_frames_sent, expected_window_full);
                $display("  Got:      frames_acknowledged=%h, frames_sent=%h, window_full=%b",
                         frames_acknowledged, frames_sent, window_full);
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
        $dumpvars(0,clk, recv_ack, reset, send_frame, frames_acknowledged, frames_sent, window_full);
    end

endmodule

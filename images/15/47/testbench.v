`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send;
    wire [3:0] received_frames;
    wire [3:0] sent_frames;
    wire [3:0] window_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send(send),
        .received_frames(received_frames),
        .sent_frames(sent_frames),
        .window_size(window_size)
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
            ack = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 5 frames", test_num);
            reset_dut();
            @(posedge clk);
            send <= 1;
            repeat(5) @(posedge clk);
            send <= 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd5, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Send 6 frames, then Acknowledge 3", test_num);
            reset_dut();
            @(posedge clk);
            send <= 1;
            repeat(6) @(posedge clk);
            send <= 0;
            ack <= 1;
            repeat(3) @(posedge clk);
            ack <= 0;
            @(posedge clk);

            #1;


            check_outputs(4'd3, 4'd6, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interleaved Send and Ack", test_num);
            reset_dut();

            send <= 1; repeat(2) @(posedge clk); send <= 0;

            ack <= 1; @(posedge clk); ack <= 0;

            send <= 1; repeat(2) @(posedge clk); send <= 0;

            ack <= 1; @(posedge clk); ack <= 0;
            @(posedge clk);

            #1;


            check_outputs(4'd2, 4'd4, 4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Send 4 and Ack 4", test_num);
            reset_dut();
            send <= 1; repeat(4) @(posedge clk); send <= 0;
            ack <= 1; repeat(4) @(posedge clk); ack <= 0;
            @(posedge clk);

            #1;


            check_outputs(4'd4, 4'd4, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter Wrap-around (17 frames)", test_num);
            reset_dut();
            send <= 1;
            repeat(17) @(posedge clk);
            send <= 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd1, 4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Send and Ack", test_num);
            reset_dut();
            @(posedge clk);
            send <= 1;
            ack <= 1;
            repeat(3) @(posedge clk);
            send <= 0;
            ack <= 0;
            @(posedge clk);

            #1;


            check_outputs(4'd3, 4'd3, 4'd0);
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
        input [3:0] expected_received_frames;
        input [3:0] expected_sent_frames;
        input [3:0] expected_window_size;
        begin
            if (expected_received_frames === (expected_received_frames ^ received_frames ^ expected_received_frames) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: received_frames=%h, sent_frames=%h, window_size=%h",
                         received_frames, sent_frames, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: received_frames=%h, sent_frames=%h, window_size=%h",
                         expected_received_frames, expected_sent_frames, expected_window_size);
                $display("  Got:      received_frames=%h, sent_frames=%h, window_size=%h",
                         received_frames, sent_frames, window_size);
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
        $dumpvars(0,ack, clk, reset, send, received_frames, sent_frames, window_size);
    end

endmodule

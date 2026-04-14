`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg rst;
    reg send_frame;
    wire [3:0] next_frame;
    wire [3:0] sent_frames;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_received(ack_received),
        .clk(clk),
        .rst(rst),
        .send_frame(send_frame),
        .next_frame(next_frame),
        .sent_frames(sent_frames)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack_received = 0;
            send_frame = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Send Single Frame", test_num);
            reset_dut();
            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Send Multiple Frames (5)", test_num);
            reset_dut();
            repeat(5) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd5, 4'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Send 5 and ACK 2", test_num);
            reset_dut();

            repeat(5) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;

            repeat(2) begin
                @(posedge clk);
                ack_received = 1;
            end
            @(posedge clk);
            ack_received = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd5, 4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Reach Window Limit (Size 8)", test_num);
            reset_dut();
            repeat(10) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd8, 4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Sequence Number Wrap-around", test_num);
            reset_dut();

            repeat(16) begin
                @(posedge clk);
                send_frame = 1;
                ack_received = 1;
            end
            @(posedge clk);
            send_frame = 0;
            ack_received = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Window Recovery", test_num);
            reset_dut();

            repeat(8) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;

            @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;

            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd9, 4'd8);
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
        input [3:0] expected_next_frame;
        input [3:0] expected_sent_frames;
        begin
            if (expected_next_frame === (expected_next_frame ^ next_frame ^ expected_next_frame) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames)) begin
                $display("PASS");
                $display("  Outputs: next_frame=%h, sent_frames=%h",
                         next_frame, sent_frames);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_frame=%h, sent_frames=%h",
                         expected_next_frame, expected_sent_frames);
                $display("  Got:      next_frame=%h, sent_frames=%h",
                         next_frame, sent_frames);
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
        $dumpvars(0,ack_received, clk, rst, send_frame, next_frame, sent_frames);
    end

endmodule

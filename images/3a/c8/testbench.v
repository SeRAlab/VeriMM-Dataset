`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send_enable;
    reg timeout;
    wire [3:0] acked_frames;
    wire busy;
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
        .rst(rst),
        .send_enable(send_enable),
        .timeout(timeout),
        .acked_frames(acked_frames),
        .busy(busy),
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
            rst = 1;
            send_enable = 0;
            ack = 0;
            timeout = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Initial Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(4'h0, 1'b0, 4'h0, window_size);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Send Single Frame", test_num);
            reset_dut();

            @(posedge clk);
            send_enable = 1;
            @(posedge clk);
            send_enable = 0;
            #5;


            #1;



            check_outputs(4'h0, 1'b0, 4'h1, window_size);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Fill the Sliding Window", test_num);
            reset_dut();



            for (i = 0; i < window_size; i = i + 1) begin
                @(posedge clk);
                send_enable = 1;
            end
            @(posedge clk);
            send_enable = 0;
            #5;


            #1;



            check_outputs(4'h0, 1'b1, window_size, window_size);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Acknowledgment Processing", test_num);
            reset_dut();


            repeat(window_size) begin
                @(posedge clk);
                send_enable = 1;
            end
            @(posedge clk);
            send_enable = 0;


            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
            #5;


            #1;



            check_outputs(4'h1, 1'b0, window_size, window_size);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Timeout Handling", test_num);
            reset_dut();


            repeat(2) begin
                @(posedge clk);
                send_enable = 1;
            end
            @(posedge clk);
            send_enable = 0;


            @(posedge clk);
            timeout = 1;
            @(posedge clk);
            timeout = 0;
            #5;


            #1;



            check_outputs(4'h0, 1'b0, 4'h0, window_size);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Continuous Transmission", test_num);
            reset_dut();


            repeat(2) begin
                @(posedge clk);
                send_enable = 1;
                @(posedge clk);
                send_enable = 0;
                @(posedge clk);
                ack = 1;
                @(posedge clk);
                ack = 0;
            end
            #5;


            #1;



            check_outputs(4'h2, 1'b0, 4'h2, window_size);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Busy State Blocking", test_num);
            reset_dut();


            repeat(window_size) begin
                @(posedge clk);
                send_enable = 1;
            end

            @(posedge clk);
            send_enable = 1;
            @(posedge clk);
            send_enable = 0;
            #5;


            #1;



            check_outputs(4'h0, 1'b1, window_size, window_size);
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
        input expected_busy;
        input [3:0] expected_sent_frames;
        input [3:0] expected_window_size;
        begin
            if (expected_acked_frames === (expected_acked_frames ^ acked_frames ^ expected_acked_frames) &&
                expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: acked_frames=%h, busy=%b, sent_frames=%h, window_size=%h",
                         acked_frames, busy, sent_frames, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_frames=%h, busy=%b, sent_frames=%h, window_size=%h",
                         expected_acked_frames, expected_busy, expected_sent_frames, expected_window_size);
                $display("  Got:      acked_frames=%h, busy=%b, sent_frames=%h, window_size=%h",
                         acked_frames, busy, sent_frames, window_size);
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
        $dumpvars(0,ack, clk, rst, send_enable, timeout, acked_frames, busy, sent_frames, window_size);
    end

endmodule

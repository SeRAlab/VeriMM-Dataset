`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    wire [1:0] frame_sent;
    wire [1:0] window_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send(send),
        .frame_sent(frame_sent),
        .window_position(window_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack = 0;
            send = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Send Frame 0 and Receive ACK", test_num);
            reset_dut();
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            ack = 1;
            @(posedge clk);
            ack = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Send Frame 0 but No ACK", test_num);
            reset_dut();
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Test %0d: Send All 4 Frames with Sequential ACKs", test_num);
            reset_dut();
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                send = 1;
                @(posedge clk);
                send = 0;
                ack = 1;
                @(posedge clk);
                ack = 0;
            end
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'b11, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Send 2 Frames with ACKs", test_num);
            reset_dut();


            @(posedge clk); send = 1; @(posedge clk); send = 0;
            ack = 1; @(posedge clk); ack = 0;


            @(posedge clk); send = 1; @(posedge clk); send = 0;
            ack = 1; @(posedge clk); ack = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'b01, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Prevent next frame without ACK", test_num);
            reset_dut();


            @(posedge clk); send = 1; @(posedge clk); send = 0;


            @(posedge clk); send = 1; @(posedge clk); send = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'b00, 2'b00);
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
        input [1:0] expected_frame_sent;
        input [1:0] expected_window_position;
        begin
            if (expected_frame_sent === (expected_frame_sent ^ frame_sent ^ expected_frame_sent) &&
                expected_window_position === (expected_window_position ^ window_position ^ expected_window_position)) begin
                $display("PASS");
                $display("  Outputs: frame_sent=%h, window_position=%h",
                         frame_sent, window_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_sent=%h, window_position=%h",
                         expected_frame_sent, expected_window_position);
                $display("  Got:      frame_sent=%h, window_position=%h",
                         frame_sent, window_position);
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
        $dumpvars(0,ack, clk, rst, send, frame_sent, window_position);
    end

endmodule

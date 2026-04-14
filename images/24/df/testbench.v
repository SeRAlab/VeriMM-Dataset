`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] ack_frame;
    reg clk;
    reg reset;
    reg send_frame;
    wire [2:0] frame_out;
    wire valid_out;

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
        .frame_out(frame_out),
        .valid_out(valid_out)
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
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task do_send;

        begin
            @(posedge clk);
            #1 send_frame = 1;
            @(posedge clk);
            #1 send_frame = 0;
        end
        endtask

    task do_ack;

        input [2:0] frame_num;
        begin
            @(posedge clk);
            #1 ack_frame = frame_num;

            @(posedge clk);
            #1 ack_frame = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Sending Frame 0 after reset", test_num);
            reset_dut();
            do_send();
            #1;

            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Fill window (0, 1, 2)", test_num);
            reset_dut();
            do_send();
            do_send();
            do_send();
            #1;

            check_outputs(3'd2, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Attempt to send frame 3 while window is full (0,1,2)", test_num);
            reset_dut();
            do_send();
            do_send();
            do_send();
            do_send();
            #1;

            check_outputs(3'd2, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: ACK frame 0 and then send frame 3", test_num);
            reset_dut();
            do_send();
            do_send();
            do_send();
            do_ack(3'd0);
            do_send();
            #1;

            check_outputs(3'd3, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Cumulative ACK for frame 2, then send 3, 4, 5", test_num);
            reset_dut();
            do_send();
            do_send();
            do_send();
            do_ack(3'd2);
            do_send();
            do_send();
            do_send();
            #1;

            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reach last frame (6)", test_num);
            reset_dut();

            do_send(); do_send(); do_send();
            do_ack(3'd2);

            do_send(); do_send(); do_send();
            do_ack(3'd5);

            do_send();
            #1;

            check_outputs(3'd6, 1'b1);
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
        input [2:0] expected_frame_out;
        input expected_valid_out;
        begin
            if (expected_frame_out === (expected_frame_out ^ frame_out ^ expected_frame_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: frame_out=%h, valid_out=%b",
                         frame_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_out=%h, valid_out=%b",
                         expected_frame_out, expected_valid_out);
                $display("  Got:      frame_out=%h, valid_out=%b",
                         frame_out, valid_out);
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
        $dumpvars(0,ack_frame, clk, reset, send_frame, frame_out, valid_out);
    end

endmodule

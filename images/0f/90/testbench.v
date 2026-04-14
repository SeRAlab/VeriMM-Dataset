`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_frame;
    reg timeout;
    wire frame_ack;
    wire frame_sent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_frame(send_frame),
        .timeout(timeout),
        .frame_ack(frame_ack),
        .frame_sent(frame_sent)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ack = 0;
            send_frame = 0;
            timeout = 0;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Send...");
            reset_dut();
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Send and ACK...");
            reset_dut();

            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);

            ack = 1;
            @(posedge clk);
            ack = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Fill Window (4 frames)...");
            reset_dut();
            for (i = 0; i < 3; i = i + 1) begin
                send_frame = 1;
                @(posedge clk);
                send_frame = 0;
                @(posedge clk);
            end

            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nRunning testcase004: Window Overflow...");
            reset_dut();
            for (i = 0; i < 4; i = i + 1) begin
                send_frame = 1;
                @(posedge clk);
                send_frame = 0;
                @(posedge clk);
            end

            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Timeout Handling...");
            reset_dut();
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);

            timeout = 1;
            @(posedge clk);
            timeout = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("\nRunning testcase006: Sliding the Window...");
            reset_dut();

            for (i = 0; i < 4; i = i + 1) begin
                send_frame = 1;
                @(posedge clk);
                send_frame = 0;
                @(posedge clk);
            end

            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);

            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            #1;

            check_outputs(0, 1);
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
        input expected_frame_ack;
        input expected_frame_sent;
        begin
            if (expected_frame_ack === (expected_frame_ack ^ frame_ack ^ expected_frame_ack) &&
                expected_frame_sent === (expected_frame_sent ^ frame_sent ^ expected_frame_sent)) begin
                $display("PASS");
                $display("  Outputs: frame_ack=%b, frame_sent=%b",
                         frame_ack, frame_sent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_ack=%b, frame_sent=%b",
                         expected_frame_ack, expected_frame_sent);
                $display("  Got:      frame_ack=%b, frame_sent=%b",
                         frame_ack, frame_sent);
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
        $dumpvars(0,ack, clk, reset, send_frame, timeout, frame_ack, frame_sent);
    end

endmodule

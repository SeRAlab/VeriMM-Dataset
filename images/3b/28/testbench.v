`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack_frame;
    reg clk;
    reg reset;
    reg send_frame;
    wire sending_ready;
    wire [3:0] window_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .ack_frame(ack_frame),
        .clk(clk),
        .reset(reset),
        .send_frame(send_frame),
        .sending_ready(sending_ready),
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
            send_frame = 0;
            ack_frame = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Frame Send");
            reset_dut();
            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Fill Window to Limit");
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nRunning testcase004: Send Full then Ack One");
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;
            ack_frame = 1;
            @(posedge clk);
            ack_frame = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 4'd7);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Simultaneous Send and Ack");
            reset_dut();

            repeat(3) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);

            send_frame = 1;
            ack_frame = 1;
            @(posedge clk);
            send_frame = 0;
            ack_frame = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 4'd3);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Multiple Acknowledgements");
            reset_dut();

            repeat(5) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;

            repeat(3) begin
                ack_frame = 1;
                @(posedge clk);
            end
            ack_frame = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 4'd2);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Saturation and Reset");
            reset_dut();

            repeat(10) begin
                @(posedge clk);
                send_frame = 1;
            end
            @(posedge clk);
            send_frame = 0;

            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 4'd0);
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
        input expected_sending_ready;
        input [3:0] expected_window_size;
        begin
            if (expected_sending_ready === (expected_sending_ready ^ sending_ready ^ expected_sending_ready) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: sending_ready=%b, window_size=%h",
                         sending_ready, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sending_ready=%b, window_size=%h",
                         expected_sending_ready, expected_window_size);
                $display("  Got:      sending_ready=%b, window_size=%h",
                         sending_ready, window_size);
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
        $dumpvars(0,ack_frame, clk, reset, send_frame, sending_ready, window_size);
    end

endmodule

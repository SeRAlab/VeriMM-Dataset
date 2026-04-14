`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_packet;
    wire sending;
    wire [1:0] window_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_received(ack_received),
        .clk(clk),
        .reset(reset),
        .send_packet(send_packet),
        .sending(sending),
        .window_position(window_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send_packet = 0;
            ack_received = 0;
            #20;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Send Single Packet", test_num);
            reset_dut();
            @(posedge clk);
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b0, 2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill Window (3 Packets)", test_num);
            reset_dut();
            repeat(3) begin
                @(posedge clk);
                send_packet = 1;
            end
            @(posedge clk);
            send_packet = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b0, 2'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exceed Window Size", test_num);
            reset_dut();

            repeat(3) begin
                @(posedge clk);
                send_packet = 1;
            end

            @(posedge clk);
            send_packet = 1;
            #2;
            if (sending !== 1'b0) begin
                $display("  Warning: 'sending' should be low when window is full!");
            end
            @(posedge clk);
            send_packet = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b0, 2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Send and ACK", test_num);
            reset_dut();

            repeat(2) begin
                @(posedge clk);
                send_packet = 1;
            end
            @(posedge clk);
            send_packet = 0;

            @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b0, 2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill and Clear Window", test_num);
            reset_dut();

            repeat(3) begin
                @(posedge clk);
                send_packet = 1;
            end
            @(posedge clk);
            send_packet = 0;

            repeat(3) begin
                @(posedge clk);
                ack_received = 1;
            end
            @(posedge clk);
            ack_received = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b0, 2'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Send and ACK", test_num);
            reset_dut();

            @(posedge clk);
            send_packet = 1;
            @(posedge clk);

            send_packet = 1;
            ack_received = 1;
            @(posedge clk);
            send_packet = 0;
            ack_received = 0;
            @(negedge clk);

            #1;


            check_outputs(1'b0, 2'd1);
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
        input expected_sending;
        input [1:0] expected_window_position;
        begin
            if (expected_sending === (expected_sending ^ sending ^ expected_sending) &&
                expected_window_position === (expected_window_position ^ window_position ^ expected_window_position)) begin
                $display("PASS");
                $display("  Outputs: sending=%b, window_position=%h",
                         sending, window_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sending=%b, window_position=%h",
                         expected_sending, expected_window_position);
                $display("  Got:      sending=%b, window_position=%h",
                         sending, window_position);
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
        $dumpvars(0,ack_received, clk, reset, send_packet, sending, window_position);
    end

endmodule

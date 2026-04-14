`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_packet;
    wire [3:0] packets_in_flight;
    wire [3:0] window_end;
    wire [3:0] window_start;

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
        .packets_in_flight(packets_in_flight),
        .window_end(window_end),
        .window_start(window_start)
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
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Initial state after reset");

            #1;


            check_outputs(4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Sending a single packet");
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd1, 4'd1, 4'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Sending 3 packets");
            send_packet = 1;
            repeat(3) @(posedge clk);
            send_packet = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd3, 4'd3, 4'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Send 1 then ACK 1");
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd1, 4'd1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Send 4 packets, ACK 2");
            send_packet = 1;
            repeat(4) @(posedge clk);
            send_packet = 0;
            ack_received = 1;
            repeat(2) @(posedge clk);
            ack_received = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd2, 4'd4, 4'd2);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Fill window (8 packets)");
            send_packet = 1;
            repeat(8) @(posedge clk);
            send_packet = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd8, 4'd8, 4'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: Interleaved Send and ACK");

            send_packet = 1;
            repeat(2) @(posedge clk);
            send_packet = 0;

            ack_received = 1;
            @(posedge clk);
            ack_received = 0;

            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd2, 4'd3, 4'd1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Testcase 008: Wrap around logic (Send 8, ACK 8, Send 2)");
            send_packet = 1;
            repeat(8) @(posedge clk);
            send_packet = 0;
            ack_received = 1;
            repeat(8) @(posedge clk);
            ack_received = 0;
            send_packet = 1;
            repeat(2) @(posedge clk);
            send_packet = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd2, 4'd10, 4'd8);
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
        input [3:0] expected_packets_in_flight;
        input [3:0] expected_window_end;
        input [3:0] expected_window_start;
        begin
            if (expected_packets_in_flight === (expected_packets_in_flight ^ packets_in_flight ^ expected_packets_in_flight) &&
                expected_window_end === (expected_window_end ^ window_end ^ expected_window_end) &&
                expected_window_start === (expected_window_start ^ window_start ^ expected_window_start)) begin
                $display("PASS");
                $display("  Outputs: packets_in_flight=%h, window_end=%h, window_start=%h",
                         packets_in_flight, window_end, window_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packets_in_flight=%h, window_end=%h, window_start=%h",
                         expected_packets_in_flight, expected_window_end, expected_window_start);
                $display("  Got:      packets_in_flight=%h, window_end=%h, window_start=%h",
                         packets_in_flight, window_end, window_start);
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
        $dumpvars(0,ack_received, clk, reset, send_packet, packets_in_flight, window_end, window_start);
    end

endmodule

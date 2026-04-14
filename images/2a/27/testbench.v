`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    wire [3:0] current_window;
    wire [3:0] packet_to_send;
    wire window_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send(send),
        .current_window(current_window),
        .packet_to_send(packet_to_send),
        .window_valid(window_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send = 0;
            ack = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial state after reset");
            reset_dut();

            #1;


            check_outputs(4'd8, 4'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Sending one packet");
            reset_dut();
            send = 1;
            @(posedge clk);
            #1 send = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd7, 4'd1, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase 003: Filling the window (8 packets)");
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                send = 1;
                @(posedge clk);
                #1 send = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(4'd0, 4'd8, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Send one packet and receive ACK");
            reset_dut();

            send = 1;
            @(posedge clk);
            #1 send = 0;
            @(posedge clk);

            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd8, 4'd1, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase 005: Recover window valid signal after ACK");
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                send = 1;
                @(posedge clk);
                #1 send = 0;
                @(posedge clk);
            end

            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd1, 4'd8, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Simultaneous send and ACK");
            reset_dut();
            send = 1;
            ack = 1;
            @(posedge clk);
            #1 send = 0;
            ack = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd8, 4'd1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Send two, Ack two");
            reset_dut();

            repeat(2) begin
                send = 1; @(posedge clk); #1 send = 0; @(posedge clk);
            end

            repeat(2) begin
                ack = 1; @(posedge clk); #1 ack = 0; @(posedge clk);
            end

            #1;


            check_outputs(4'd8, 4'd2, 1'b1);
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
        input [3:0] expected_current_window;
        input [3:0] expected_packet_to_send;
        input expected_window_valid;
        begin
            if (expected_current_window === (expected_current_window ^ current_window ^ expected_current_window) &&
                expected_packet_to_send === (expected_packet_to_send ^ packet_to_send ^ expected_packet_to_send) &&
                expected_window_valid === (expected_window_valid ^ window_valid ^ expected_window_valid)) begin
                $display("PASS");
                $display("  Outputs: current_window=%h, packet_to_send=%h, window_valid=%b",
                         current_window, packet_to_send, window_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_window=%h, packet_to_send=%h, window_valid=%b",
                         expected_current_window, expected_packet_to_send, expected_window_valid);
                $display("  Got:      current_window=%h, packet_to_send=%h, window_valid=%b",
                         current_window, packet_to_send, window_valid);
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
        $dumpvars(0,ack, clk, rst, send, current_window, packet_to_send, window_valid);
    end

endmodule

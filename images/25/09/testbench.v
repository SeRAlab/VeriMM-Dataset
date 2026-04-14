`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_packet;
    wire sending;
    wire [2:0] window_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_packet(send_packet),
        .sending(sending),
        .window_count(window_count)
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
            ack = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset state");
            reset_dut();
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single packet send");
            reset_dut();
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Send then Ack");
            reset_dut();
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            ack = 1;
            @(posedge clk);
            ack = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Fill window (size 4)");
            reset_dut();
            send_packet = 1;
            for(i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            send_packet = 0;
            #1;

            check_outputs(1, 4);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Window saturation check");
            reset_dut();
            send_packet = 1;
            for(i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            send_packet = 0;


            if (window_count > 0) begin
                $display("PASS: Window saturated at %d", window_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Window wrapped around to 0");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Simultaneous send and ack");
            reset_dut();

            send_packet = 1;
            @(posedge clk);

            send_packet = 1;
            ack = 1;
            @(posedge clk);
            send_packet = 0;
            ack = 0;

            #1;


            check_outputs(1, 1);
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
        input expected_sending;
        input [2:0] expected_window_count;
        begin
            if (expected_sending === (expected_sending ^ sending ^ expected_sending) &&
                expected_window_count === (expected_window_count ^ window_count ^ expected_window_count)) begin
                $display("PASS");
                $display("  Outputs: sending=%b, window_count=%h",
                         sending, window_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sending=%b, window_count=%h",
                         expected_sending, expected_window_count);
                $display("  Got:      sending=%b, window_count=%h",
                         sending, window_count);
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
        $dumpvars(0,ack, clk, reset, send_packet, sending, window_count);
    end

endmodule

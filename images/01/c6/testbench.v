`timescale 1ns/1ps

module ARQ_Controller_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg rst;
    reg timeout;
    wire retransmit;
    wire send_packet;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_Controller dut (
        .ack_received(ack_received),
        .clk(clk),
        .rst(rst),
        .timeout(timeout),
        .retransmit(retransmit),
        .send_packet(send_packet),
        .state(state)
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
            timeout = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Successful Transmission");
            reset_dut();

            ack_received = 1;
            #10;
            ack_received = 0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Timeout and Retransmission");
            reset_dut();

            timeout = 1;
            #10;
            timeout = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Persistence in WAIT State");
            reset_dut();

            ack_received = 0;
            timeout = 0;
            #30;

            #1;


            check_outputs(1'b0, 1'b0, 2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Recovery after Retransmission");
            reset_dut();

            timeout = 1;
            #10;
            timeout = 0;
            #10;
            #10;
            ack_received = 1;
            #10;
            ack_received = 0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Simultaneous ACK and Timeout");
            reset_dut();
            ack_received = 1;
            timeout = 1;
            #10;


            #1;



            check_outputs(1'b0, 1'b1, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_Controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_retransmit;
        input expected_send_packet;
        input [1:0] expected_state;
        begin
            if (expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit) &&
                expected_send_packet === (expected_send_packet ^ send_packet ^ expected_send_packet) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: retransmit=%b, send_packet=%b, state=%h",
                         retransmit, send_packet, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: retransmit=%b, send_packet=%b, state=%h",
                         expected_retransmit, expected_send_packet, expected_state);
                $display("  Got:      retransmit=%b, send_packet=%b, state=%h",
                         retransmit, send_packet, state);
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
        $dumpvars(0,ack_received, clk, rst, timeout, retransmit, send_packet, state);
    end

endmodule

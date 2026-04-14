`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] ack;
    reg clk;
    reg rst;
    reg send_enable;
    wire [1:0] packet_out;
    wire send_ready;

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
        .packet_out(packet_out),
        .send_ready(send_ready)
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
            ack = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Initial state and first packet transmission");
            reset_dut();


            if (send_ready == 1 && packet_out == 2'b00) begin
                send_enable = 1;
                @(posedge clk);
                #1 send_enable = 0;


                ack = 2'b00;
                @(posedge clk);
                #1;

                #1;


                check_outputs(2'b01, 1'b1);
            end else begin
                $display("FAIL: Initial state incorrect");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Verify sender waits for ACK");
            reset_dut();


            send_enable = 1;
            @(posedge clk);
            #1 send_enable = 0;


            ack = 2'b11;
            repeat(3) @(posedge clk);

            #1;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nTestcase 003: Full wrap-around (Packets 0-3)");
            reset_dut();

            for (i = 0; i < 4; i = i + 1) begin
                send_enable = 1;
                @(posedge clk);
                #1 send_enable = 0;

                ack = i[1:0];
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: No transmission if send_enable is low");
            reset_dut();

            send_enable = 0;
            repeat(3) @(posedge clk);

            #1;

            #1;


            check_outputs(2'b00, 1'b1);
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
        input [1:0] expected_packet_out;
        input expected_send_ready;
        begin
            if (expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out) &&
                expected_send_ready === (expected_send_ready ^ send_ready ^ expected_send_ready)) begin
                $display("PASS");
                $display("  Outputs: packet_out=%h, send_ready=%b",
                         packet_out, send_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_out=%h, send_ready=%b",
                         expected_packet_out, expected_send_ready);
                $display("  Got:      packet_out=%h, send_ready=%b",
                         packet_out, send_ready);
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
        $dumpvars(0,ack, clk, rst, send_enable, packet_out, send_ready);
    end

endmodule

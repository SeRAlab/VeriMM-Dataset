`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send_packet;
    wire [7:0] packet_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send_packet(send_packet),
        .packet_out(packet_out),
        .valid_out(valid_out)
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
            send_packet = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset State");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Send Single Packet");
            reset_dut();
            @(posedge clk);
            send_packet = 1;
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
            @(posedge clk);
            send_packet = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Send Multiple Packets");
            reset_dut();


            @(posedge clk); send_packet = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02, 1'b1);
            send_packet = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Window Limit Enforcement");
            reset_dut();

            @(posedge clk); send_packet = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(packet_out, 1'b0);
            send_packet = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Window Advancement on ACK");
            reset_dut();

            @(posedge clk); send_packet = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk); send_packet = 0;


            @(posedge clk); ack = 1;
            @(posedge clk); ack = 0;


            @(posedge clk); send_packet = 1;
            #1;
            #1;

            check_outputs(8'h04, 1'b1);
            @(posedge clk); send_packet = 0;
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
        input [7:0] expected_packet_out;
        input expected_valid_out;
        begin
            if (expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: packet_out=%h, valid_out=%b",
                         packet_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_out=%h, valid_out=%b",
                         expected_packet_out, expected_valid_out);
                $display("  Got:      packet_out=%h, valid_out=%b",
                         packet_out, valid_out);
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
        $dumpvars(0,ack, clk, rst, send_packet, packet_out, valid_out);
    end

endmodule

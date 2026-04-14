`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    wire [3:0] packet_id;
    wire sent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send(send),
        .packet_id(packet_id),
        .sent(sent)
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
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial State after Reset");
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Successful Transaction");
            reset_dut();


            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;


            wait(sent == 1'b1);
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sender blocks until ACK is received");
            reset_dut();


            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;


            wait(sent == 1'b1);
            repeat(5) @(posedge clk);


            send = 1;
            @(posedge clk);
            send = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple Sequential Transactions");
            reset_dut();


            @(posedge clk);
            send = 1; @(posedge clk); send = 0;
            wait(sent == 1'b1);
            @(posedge clk); ack = 1; @(posedge clk); ack = 0;


            @(posedge clk);
            send = 1; @(posedge clk); send = 0;
            wait(sent == 1'b1);
            @(posedge clk); ack = 1; @(posedge clk); ack = 0;

            @(posedge clk);

            #1;


            check_outputs(4'h2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: System Reset during operation");
            reset_dut();


            @(posedge clk);
            send = 1;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stop_and_wait Testbench");
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
        input [3:0] expected_packet_id;
        input expected_sent;
        begin
            if (expected_packet_id === (expected_packet_id ^ packet_id ^ expected_packet_id) &&
                expected_sent === (expected_sent ^ sent ^ expected_sent)) begin
                $display("PASS");
                $display("  Outputs: packet_id=%h, sent=%b",
                         packet_id, sent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_id=%h, sent=%b",
                         expected_packet_id, expected_sent);
                $display("  Got:      packet_id=%h, sent=%b",
                         packet_id, sent);
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
        $dumpvars(0,ack, clk, rst, send, packet_id, sent);
    end

endmodule

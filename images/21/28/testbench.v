`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg recv_ack;
    reg rst;
    wire [2:0] packet_sent;
    wire resend;
    wire send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .clk(clk),
        .recv_ack(recv_ack),
        .rst(rst),
        .packet_sent(packet_sent),
        .resend(resend),
        .send(send)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            recv_ack = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Normal Sequence - Start and send first ACK", test_num);
            reset_dut();

            recv_ack = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Retransmission - No ACK provided", test_num);
            reset_dut();

            recv_ack = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Full Sequence - Send Packets 0 to 4", test_num);
            reset_dut();

            recv_ack = 1; @(posedge clk); #1;
            recv_ack = 1; @(posedge clk); #1;
            recv_ack = 1; @(posedge clk); #1;
            recv_ack = 1; @(posedge clk); #1;
            recv_ack = 0;
            #1;

            check_outputs(3'd4, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Fail and Recover - Packet 1 fails once", test_num);
            reset_dut();

            recv_ack = 1; @(posedge clk); #1;

            recv_ack = 0; @(posedge clk); #1;

            recv_ack = 1; @(posedge clk); #1;
            #1;

            check_outputs(3'd2, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary - behavior after Packet 4 ACK", test_num);
            reset_dut();

            recv_ack = 1; @(posedge clk); #1;
            recv_ack = 1; @(posedge clk); #1;
            recv_ack = 1; @(posedge clk); #1;
            recv_ack = 1; @(posedge clk); #1;
            recv_ack = 1; @(posedge clk); #1;


            #1;



            check_outputs(3'd4, 1'b0, 1'b1);
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
        input [2:0] expected_packet_sent;
        input expected_resend;
        input expected_send;
        begin
            if (expected_packet_sent === (expected_packet_sent ^ packet_sent ^ expected_packet_sent) &&
                expected_resend === (expected_resend ^ resend ^ expected_resend) &&
                expected_send === (expected_send ^ send ^ expected_send)) begin
                $display("PASS");
                $display("  Outputs: packet_sent=%h, resend=%b, send=%b",
                         packet_sent, resend, send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_sent=%h, resend=%b, send=%b",
                         expected_packet_sent, expected_resend, expected_send);
                $display("  Got:      packet_sent=%h, resend=%b, send=%b",
                         packet_sent, resend, send);
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
        $dumpvars(0,clk, recv_ack, rst, packet_sent, resend, send);
    end

endmodule

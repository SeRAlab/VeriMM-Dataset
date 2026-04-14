`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send;
    reg timeout;
    wire ack_out;
    wire [7:0] packet_out;
    wire retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send(send),
        .timeout(timeout),
        .ack_out(ack_out),
        .packet_out(packet_out),
        .retransmit(retransmit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            send = 0;
            timeout = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Send and ACK", test_num);
            reset_dut();

            send = 1;
            @(posedge clk);
            send = 0;

            repeat(2) @(posedge clk);

            ack = 1;
            @(posedge clk);
            ack = 0;


            #1;



            check_outputs(1, packet_out, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Timeout and Retransmit", test_num);
            reset_dut();

            send = 1;
            @(posedge clk);
            send = 0;

            repeat(3) @(posedge clk);

            timeout = 1;
            @(posedge clk);
            timeout = 0;


            #1;



            check_outputs(0, packet_out, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ACK after Retransmission", test_num);
            reset_dut();

            send = 1;
            @(posedge clk);
            send = 0;

            timeout = 1;
            @(posedge clk);
            timeout = 0;

            repeat(2) @(posedge clk);

            ack = 1;
            @(posedge clk);
            ack = 0;


            #1;



            check_outputs(1, packet_out, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Idle State Check", test_num);
            reset_dut();

            repeat(5) @(posedge clk);


            #1;



            check_outputs(0, 8'h00, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive Successful Transmissions", test_num);
            reset_dut();


            send = 1;
            @(posedge clk);
            send = 0;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;

            repeat(2) @(posedge clk);


            send = 1;
            @(posedge clk);
            send = 0;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;


            #1;



            check_outputs(1, packet_out, 0);
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
        input expected_ack_out;
        input [7:0] expected_packet_out;
        input expected_retransmit;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out) &&
                expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b, packet_out=%h, retransmit=%b",
                         ack_out, packet_out, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b, packet_out=%h, retransmit=%b",
                         expected_ack_out, expected_packet_out, expected_retransmit);
                $display("  Got:      ack_out=%b, packet_out=%h, retransmit=%b",
                         ack_out, packet_out, retransmit);
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
        $dumpvars(0,ack, clk, reset, send, timeout, ack_out, packet_out, retransmit);
    end

endmodule

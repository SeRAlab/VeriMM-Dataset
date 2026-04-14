`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send;
    wire [3:0] acked_packets;
    wire [3:0] sent_packets;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send(send),
        .acked_packets(acked_packets),
        .sent_packets(sent_packets)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send = 0;
            ack = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clk);
            send = 1;
            @(negedge clk);
            send = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clk);
            repeat(4) begin
                send = 1;
                @(negedge clk);
            end
            send = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(0, 4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clk);
            repeat(6) begin
                send = 1;
                @(negedge clk);
            end
            send = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(0, 4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clk);

            repeat(4) begin
                send = 1; @(negedge clk);
            end
            send = 0;

            repeat(2) begin
                ack = 1; @(negedge clk);
            end
            ack = 0;

            repeat(2) begin
                send = 1; @(negedge clk);
            end
            send = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2, 6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clk);

            repeat(4) begin send = 1; @(negedge clk); end
            send = 0;

            repeat(4) begin ack = 1; @(negedge clk); end
            ack = 0;

            repeat(4) begin send = 1; @(negedge clk); end
            send = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(4, 8);
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
        input [3:0] expected_acked_packets;
        input [3:0] expected_sent_packets;
        begin
            if (expected_acked_packets === (expected_acked_packets ^ acked_packets ^ expected_acked_packets) &&
                expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets)) begin
                $display("PASS");
                $display("  Outputs: acked_packets=%h, sent_packets=%h",
                         acked_packets, sent_packets);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acked_packets=%h, sent_packets=%h",
                         expected_acked_packets, expected_sent_packets);
                $display("  Got:      acked_packets=%h, sent_packets=%h",
                         acked_packets, sent_packets);
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
        $dumpvars(0,ack, clk, reset, send, acked_packets, sent_packets);
    end

endmodule

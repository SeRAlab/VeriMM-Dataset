`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send_packet;
    wire [3:0] ack_packets;
    wire [3:0] sent_packets;

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
        .ack_packets(ack_packets),
        .sent_packets(sent_packets)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send_packet = 0;
            ack = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Sending (3 packets)", test_num);
            reset_dut();

            repeat(3) begin
                send_packet = 1;
                @(posedge clk);
                #1;
            end
            send_packet = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Acknowledgment", test_num);
            reset_dut();


            send_packet = 1;
            repeat(2) @(posedge clk);
            #1 send_packet = 0;


            ack = 1;
            repeat(2) @(posedge clk);
            #1 ack = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd2, 4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Window Limit and Slide", test_num);
            reset_dut();


            send_packet = 1;
            repeat(10) @(posedge clk);
            #1 send_packet = 0;


            ack = 1;
            repeat(2) @(posedge clk);
            #1 ack = 0;


            send_packet = 1;
            @(posedge clk);
            #1 send_packet = 0;
            @(posedge clk);



            #1;




            check_outputs(4'd2, 4'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Send and Ack", test_num);
            reset_dut();

            send_packet = 1;
            ack = 1;
            repeat(5) @(posedge clk);
            #1;
            send_packet = 0;
            ack = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd5, 4'd5);
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
        input [3:0] expected_ack_packets;
        input [3:0] expected_sent_packets;
        begin
            if (expected_ack_packets === (expected_ack_packets ^ ack_packets ^ expected_ack_packets) &&
                expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets)) begin
                $display("PASS");
                $display("  Outputs: ack_packets=%h, sent_packets=%h",
                         ack_packets, sent_packets);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_packets=%h, sent_packets=%h",
                         expected_ack_packets, expected_sent_packets);
                $display("  Got:      ack_packets=%h, sent_packets=%h",
                         ack_packets, sent_packets);
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
        $dumpvars(0,ack, clk, rst, send_packet, ack_packets, sent_packets);
    end

endmodule

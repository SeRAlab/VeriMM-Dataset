`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    wire [3:0] acknowledged_packets;
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
        .send(send),
        .acknowledged_packets(acknowledged_packets),
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
        send = 0;
        ack = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Reset State Verification", test_num);
        reset_dut();
        #1;

        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Single Packet Send and Ack", test_num);
        reset_dut();


        @(posedge clk);
        send = 1;
        @(posedge clk);
        send = 0;


        @(posedge clk);
        ack = 1;
        @(posedge clk);
        ack = 0;

        #1;


        check_outputs(4'h1, 4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Fill Window (4 packets)", test_num);
        reset_dut();

        repeat(4) begin
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
        end

        #1;


        check_outputs(4'h0, 4'h4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: Exceed Window Limit", test_num);
        reset_dut();

        repeat(5) begin
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
        end


        #1;



        check_outputs(4'h0, 4'h4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: Sliding Window Logic", test_num);
        reset_dut();


        repeat(4) begin
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
        end


        repeat(2) begin
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
        end


        repeat(2) begin
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
        end

        #1;


        check_outputs(4'h2, 4'h6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %03d: Interleaved Send/Ack", test_num);
        reset_dut();

        repeat(3) begin
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
        end

        #1;


        check_outputs(4'h3, 4'h3);
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
        input [3:0] expected_acknowledged_packets;
        input [3:0] expected_sent_packets;
        begin
            if (expected_acknowledged_packets === (expected_acknowledged_packets ^ acknowledged_packets ^ expected_acknowledged_packets) &&
                expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets)) begin
                $display("PASS");
                $display("  Outputs: acknowledged_packets=%h, sent_packets=%h",
                         acknowledged_packets, sent_packets);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acknowledged_packets=%h, sent_packets=%h",
                         expected_acknowledged_packets, expected_sent_packets);
                $display("  Got:      acknowledged_packets=%h, sent_packets=%h",
                         acknowledged_packets, sent_packets);
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
        $dumpvars(0,ack, clk, rst, send, acknowledged_packets, sent_packets);
    end

endmodule

`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] packet_data;
    reg rst;
    reg send_packet;
    wire ack;
    wire [7:0] sent_packet;
    wire [1:0] window_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .clk(clk),
        .packet_data(packet_data),
        .rst(rst),
        .send_packet(send_packet),
        .ack(ack),
        .sent_packet(sent_packet),
        .window_status(window_status)
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
        packet_data = 8'h00;
        #20;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(1'b0, 8'h00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        packet_data = 8'hA1;
        send_packet = 1;
        @(posedge clk);
        send_packet = 0;
        #1;

        #1;


        check_outputs(1'b0, 8'hA1, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(posedge clk);
        packet_data = 8'h10; send_packet = 1; @(posedge clk);
        packet_data = 8'h20; send_packet = 1; @(posedge clk);
        send_packet = 0;
        #1;

        #1;


        check_outputs(1'b0, 8'h20, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        @(posedge clk);
        packet_data = 8'h11; send_packet = 1; @(posedge clk);
        packet_data = 8'h22; send_packet = 1; @(posedge clk);
        packet_data = 8'h33; send_packet = 1; @(posedge clk);
        send_packet = 0;
        #1;

        #1;


        check_outputs(1'b0, 8'h33, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(posedge clk);
        packet_data = 8'hAA; send_packet = 1; @(posedge clk);
        send_packet = 0;


        repeat(5) @(posedge clk);




        #1;





        check_outputs(ack, 8'hAA, 2'b00);
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
        input expected_ack;
        input [7:0] expected_sent_packet;
        input [1:0] expected_window_status;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_sent_packet === (expected_sent_packet ^ sent_packet ^ expected_sent_packet) &&
                expected_window_status === (expected_window_status ^ window_status ^ expected_window_status)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, sent_packet=%h, window_status=%h",
                         ack, sent_packet, window_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, sent_packet=%h, window_status=%h",
                         expected_ack, expected_sent_packet, expected_window_status);
                $display("  Got:      ack=%b, sent_packet=%h, window_status=%h",
                         ack, sent_packet, window_status);
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
        $dumpvars(0,clk, packet_data, rst, send_packet, ack, sent_packet, window_status);
    end

endmodule

`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_packet;
    wire send_enable;
    wire [3:0] window_end;
    wire [3:0] window_start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_received(ack_received),
        .clk(clk),
        .reset(reset),
        .send_packet(send_packet),
        .send_enable(send_enable),
        .window_end(window_end),
        .window_start(window_start)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        send_packet = 0;
        ack_received = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %03d: Initial State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %03d: Send Single Packet", test_num);
        reset_dut();

        send_packet = 1;
        @(posedge clk);
        #1 send_packet = 0;
        @(posedge clk);


        #1;



        check_outputs(1'b1, 4'd1, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %03d: Fill Window (Size 4)", test_num);
        reset_dut();

        repeat(4) begin
            send_packet = 1;
            @(posedge clk);
            #1 send_packet = 0;
            @(posedge clk);
        end


        #1;



        check_outputs(1'b0, 4'd4, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %03d: Slide Window with ACK", test_num);
        reset_dut();


        repeat(4) begin
            send_packet = 1;
            @(posedge clk);
            #1 send_packet = 0;
            @(posedge clk);
        end


        ack_received = 1;
        @(posedge clk);
        #1 ack_received = 0;
        @(posedge clk);


        #1;



        check_outputs(1'b1, 4'd4, 4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %03d: Send After Sliding", test_num);
        reset_dut();


        repeat(4) begin
            send_packet = 1; @(posedge clk); #1 send_packet = 0; @(posedge clk);
        end
        ack_received = 1; @(posedge clk); #1 ack_received = 0; @(posedge clk);


        send_packet = 1;
        @(posedge clk);
        #1 send_packet = 0;
        @(posedge clk);


        #1;



        check_outputs(1'b0, 4'd5, 4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %03d: Multiple ACKs", test_num);
        reset_dut();


        repeat(4) begin
            send_packet = 1; @(posedge clk); #1 send_packet = 0; @(posedge clk);
        end


        repeat(3) begin
            ack_received = 1;
            @(posedge clk);
            #1 ack_received = 0;
            @(posedge clk);
        end


        #1;



        check_outputs(1'b1, 4'd4, 4'd3);
    end
        endtask

    task testcase007;

    integer i;
    begin
        test_num = 7;
        $display("\nTest Case %03d: Wrap-around logic", test_num);
        reset_dut();


        for(i=0; i<15; i=i+1) begin
            send_packet = 1; @(posedge clk); #1 send_packet = 0; @(posedge clk);
            ack_received = 1; @(posedge clk); #1 ack_received = 0; @(posedge clk);
        end


        send_packet = 1;
        @(posedge clk);
        #1 send_packet = 0;
        @(posedge clk);


        #1;



        check_outputs(1'b1, 4'd0, 4'd15);
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
        testcase007();
        
        
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
        input expected_send_enable;
        input [3:0] expected_window_end;
        input [3:0] expected_window_start;
        begin
            if (expected_send_enable === (expected_send_enable ^ send_enable ^ expected_send_enable) &&
                expected_window_end === (expected_window_end ^ window_end ^ expected_window_end) &&
                expected_window_start === (expected_window_start ^ window_start ^ expected_window_start)) begin
                $display("PASS");
                $display("  Outputs: send_enable=%b, window_end=%h, window_start=%h",
                         send_enable, window_end, window_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: send_enable=%b, window_end=%h, window_start=%h",
                         expected_send_enable, expected_window_end, expected_window_start);
                $display("  Got:      send_enable=%b, window_end=%h, window_start=%h",
                         send_enable, window_end, window_start);
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
        $dumpvars(0,ack_received, clk, reset, send_packet, send_enable, window_end, window_start);
    end

endmodule

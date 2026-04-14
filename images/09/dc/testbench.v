`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_pkt;
    wire [3:0] ack_count;
    wire [3:0] sent_count;
    wire window_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_received(ack_received),
        .clk(clk),
        .reset(reset),
        .send_pkt(send_pkt),
        .ack_count(ack_count),
        .sent_count(sent_count),
        .window_full(window_full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send_pkt = 0;
            ack_received = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Send Single Packet", test_num);
            reset_dut();
            send_pkt = 1;
            @(posedge clk);
            send_pkt = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %03d: Send 4 Packets", test_num);
            reset_dut();
            for (i = 0; i < 4; i = i + 1) begin
                send_pkt = 1;
                @(posedge clk);
                send_pkt = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(4'd0, 4'd4, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %03d: Fill Window (8 Packets)", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                send_pkt = 1;
                @(posedge clk);
                send_pkt = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(4'd0, 4'd8, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %03d: Send Attempt while Full", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                send_pkt = 1;
                @(posedge clk);
            end

            send_pkt = 1;
            @(posedge clk);
            send_pkt = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd8, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("\nTestcase %03d: Receive ACK and Slide Window", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                send_pkt = 1;
                @(posedge clk);
            end
            send_pkt = 0;

            ack_received = 1;
            repeat(2) @(posedge clk);
            ack_received = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd2, 4'd8, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("\nTestcase %03d: Counter Roll-over Check", test_num);
            reset_dut();

            for (i = 0; i < 14; i = i + 1) begin
                send_pkt = 1;
                ack_received = 1;
                @(posedge clk);
            end

            ack_received = 0;
            for (i = 0; i < 4; i = i + 1) begin
                send_pkt = 1;
                @(posedge clk);
            end
            send_pkt = 0;
            @(posedge clk);




            #1;





            check_outputs(4'hE, 4'h2, 1'b0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("\nTestcase %03d: Complex Flow", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                send_pkt = 1; @(posedge clk);
            end
            send_pkt = 0;

            ack_received = 1; repeat(4) @(posedge clk);
            ack_received = 0;

            send_pkt = 1; repeat(2) @(posedge clk);
            send_pkt = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd4, 4'hA, 1'b0);
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
        testcase008();
        
        
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
        input [3:0] expected_ack_count;
        input [3:0] expected_sent_count;
        input expected_window_full;
        begin
            if (expected_ack_count === (expected_ack_count ^ ack_count ^ expected_ack_count) &&
                expected_sent_count === (expected_sent_count ^ sent_count ^ expected_sent_count) &&
                expected_window_full === (expected_window_full ^ window_full ^ expected_window_full)) begin
                $display("PASS");
                $display("  Outputs: ack_count=%h, sent_count=%h, window_full=%b",
                         ack_count, sent_count, window_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_count=%h, sent_count=%h, window_full=%b",
                         expected_ack_count, expected_sent_count, expected_window_full);
                $display("  Got:      ack_count=%h, sent_count=%h, window_full=%b",
                         ack_count, sent_count, window_full);
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
        $dumpvars(0,ack_received, clk, reset, send_pkt, ack_count, sent_count, window_full);
    end

endmodule

`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send;
    wire [1:0] ack_count;
    wire empty;
    wire full;
    wire [1:0] sent_count;

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
        .ack_count(ack_count),
        .empty(empty),
        .full(full),
        .sent_count(sent_count)
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
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Send Single Packet", test_num);
            reset_dut();
            send = 1;
            @(posedge clk);
            #1;
            send = 0;

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Fill Window (3 packets)", test_num);
            reset_dut();
            send = 1;
            repeat(3) @(posedge clk);
            #1;
            send = 0;

            #1;


            check_outputs(2'b00, 1'b0, 1'b1, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Acknowledge 1 Packet from Full", test_num);
            reset_dut();

            send = 1;
            repeat(3) @(posedge clk);
            #1;
            send = 0;

            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;

            #1;


            check_outputs(2'b01, 1'b0, 1'b0, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Complete Send and Ack Cycle", test_num);
            reset_dut();

            send = 1;
            repeat(3) @(posedge clk);
            #1;
            send = 0;

            ack = 1;
            repeat(3) @(posedge clk);
            #1;
            ack = 0;

            #1;


            check_outputs(2'b11, 1'b1, 1'b0, 2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Prevent Send Over Window Limit", test_num);
            reset_dut();

            send = 1;
            repeat(4) @(posedge clk);
            #1;
            send = 0;

            #1;


            check_outputs(2'b00, 1'b0, 1'b1, 2'b11);
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
        input [1:0] expected_ack_count;
        input expected_empty;
        input expected_full;
        input [1:0] expected_sent_count;
        begin
            if (expected_ack_count === (expected_ack_count ^ ack_count ^ expected_ack_count) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_sent_count === (expected_sent_count ^ sent_count ^ expected_sent_count)) begin
                $display("PASS");
                $display("  Outputs: ack_count=%h, empty=%b, full=%b, sent_count=%h",
                         ack_count, empty, full, sent_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_count=%h, empty=%b, full=%b, sent_count=%h",
                         expected_ack_count, expected_empty, expected_full, expected_sent_count);
                $display("  Got:      ack_count=%h, empty=%b, full=%b, sent_count=%h",
                         ack_count, empty, full, sent_count);
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
        $dumpvars(0,ack, clk, reset, send, ack_count, empty, full, sent_count);
    end

endmodule

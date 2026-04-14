`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    wire [3:0] next_sequence_number;
    wire [3:0] window_size;

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
        .next_sequence_number(next_sequence_number),
        .window_size(window_size)
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
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Single Packet Send", test_num);
        reset_dut();
        send = 1;
        @(posedge clk);
        #1;
        send = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'd1, 4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Multiple Packet Sends", test_num);
        reset_dut();
        send = 1;
        repeat(5) @(posedge clk);
        #1;
        send = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'd5, 4'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Send and Receive ACK", test_num);
        reset_dut();


        send = 1;
        repeat(3) @(posedge clk);
        #1;
        send = 0;


        ack = 1;
        @(posedge clk);
        #1;
        ack = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd3, 4'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Sequence Number Wrap-around", test_num);
        reset_dut();


        send = 1;
        repeat(16) @(posedge clk);
        #1;
        send = 0;
        @(posedge clk);
        #1;




        #1;





        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Interleaved Send and ACK", test_num);
        reset_dut();


        send = 1;
        repeat(2) @(posedge clk);
        #1;


        ack = 1;
        @(posedge clk);
        #1;


        send = 0;
        ack = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd3, 4'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: ACK on Empty Window", test_num);
        reset_dut();


        ack = 1;
        @(posedge clk);
        #1;
        ack = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Full Cycle Send and ACK", test_num);
        reset_dut();


        send = 1;
        repeat(8) @(posedge clk);
        #1;
        send = 0;


        ack = 1;
        repeat(8) @(posedge clk);
        #1;
        ack = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'd8, 4'd0);
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
        input [3:0] expected_next_sequence_number;
        input [3:0] expected_window_size;
        begin
            if (expected_next_sequence_number === (expected_next_sequence_number ^ next_sequence_number ^ expected_next_sequence_number) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: next_sequence_number=%h, window_size=%h",
                         next_sequence_number, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_sequence_number=%h, window_size=%h",
                         expected_next_sequence_number, expected_window_size);
                $display("  Got:      next_sequence_number=%h, window_size=%h",
                         next_sequence_number, window_size);
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
        $dumpvars(0,ack, clk, rst, send, next_sequence_number, window_size);
    end

endmodule

`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    reg [3:0] window_size;
    wire [3:0] ack_count;
    wire [3:0] sent_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send(send),
        .window_size(window_size),
        .ack_count(ack_count),
        .sent_count(sent_count)
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
            window_size = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Send and Ack", test_num);
            reset_dut();

            window_size = 4'd4;


            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;


            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;

            @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill Window", test_num);
            reset_dut();

            window_size = 4'd3;


            @(posedge clk);
            send = 1;
            repeat (3) @(posedge clk);
            send = 0;

            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Exceed Window Size", test_num);
            reset_dut();

            window_size = 4'd2;


            @(posedge clk);
            send = 1;
            repeat (5) @(posedge clk);
            send = 0;

            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sliding Window Motion", test_num);
            reset_dut();

            window_size = 4'd2;


            @(posedge clk);
            send = 1;
            repeat (2) @(posedge clk);
            send = 0;


            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;


            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;

            @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Send and Ack", test_num);
            reset_dut();

            window_size = 4'd5;


            @(posedge clk);
            send = 1;
            repeat (3) @(posedge clk);


            ack = 1;
            repeat (2) @(posedge clk);

            send = 0;
            ack = 0;

            @(posedge clk);


            #1;



            check_outputs(4'd2, 4'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-operation", test_num);
            reset_dut();

            window_size = 4'd8;
            @(posedge clk);
            send = 1;
            repeat (4) @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            send = 0;

            @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_controller Testbench");
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
        input [3:0] expected_ack_count;
        input [3:0] expected_sent_count;
        begin
            if (expected_ack_count === (expected_ack_count ^ ack_count ^ expected_ack_count) &&
                expected_sent_count === (expected_sent_count ^ sent_count ^ expected_sent_count)) begin
                $display("PASS");
                $display("  Outputs: ack_count=%h, sent_count=%h",
                         ack_count, sent_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_count=%h, sent_count=%h",
                         expected_ack_count, expected_sent_count);
                $display("  Got:      ack_count=%h, sent_count=%h",
                         ack_count, sent_count);
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
        $dumpvars(0,ack, clk, rst, send, window_size, ack_count, sent_count);
    end

endmodule

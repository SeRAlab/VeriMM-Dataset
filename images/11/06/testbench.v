`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_frame;
    wire [3:0] acknowledged_frames;
    wire [3:0] sent_frames;
    wire window_empty;
    wire window_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_frame(send_frame),
        .acknowledged_frames(acknowledged_frames),
        .sent_frames(sent_frames),
        .window_empty(window_empty),
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
        ack = 0;
        send_frame = 0;
        #20;
        reset = 0;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nRunning Testcase %0d: Initial State", test_num);
        reset_dut();

        #1;


        check_outputs(4'd0, 4'd0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nRunning Testcase %0d: Send Single Frame", test_num);
        reset_dut();

        @(posedge clk);
        send_frame = 1;
        @(posedge clk);
        send_frame = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(4'd0, 4'd1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("\nRunning Testcase %0d: Fill Window", test_num);
        reset_dut();

        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
        end
        repeat(2) @(posedge clk);


        #1;



        check_outputs(4'd0, 4'd8, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("\nRunning Testcase %0d: Send and Partial Ack", test_num);
        reset_dut();


        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
        end


        for (i = 0; i < 2; i = i + 1) begin
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
        end
        repeat(2) @(posedge clk);


        #1;



        check_outputs(4'd2, 4'd5, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("\nRunning Testcase %0d: Fill and Clear Window", test_num);
        reset_dut();


        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
        end


        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
        end
        repeat(2) @(posedge clk);


        #1;



        check_outputs(4'd8, 4'd8, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = 6;
        $display("\nRunning Testcase %0d: Window Overflow Prevention", test_num);
        reset_dut();


        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
        end
        repeat(2) @(posedge clk);



        #1;




        check_outputs(4'd0, 4'd8, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nRunning Testcase %0d: Simultaneous Send and Ack", test_num);
        reset_dut();


        repeat(4) begin
            @(posedge clk);
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
        end


        @(posedge clk);
        send_frame = 1;
        ack = 1;
        @(posedge clk);
        send_frame = 0;
        ack = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(4'd1, 4'd5, 1'b0, 1'b0);
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
        input [3:0] expected_acknowledged_frames;
        input [3:0] expected_sent_frames;
        input expected_window_empty;
        input expected_window_full;
        begin
            if (expected_acknowledged_frames === (expected_acknowledged_frames ^ acknowledged_frames ^ expected_acknowledged_frames) &&
                expected_sent_frames === (expected_sent_frames ^ sent_frames ^ expected_sent_frames) &&
                expected_window_empty === (expected_window_empty ^ window_empty ^ expected_window_empty) &&
                expected_window_full === (expected_window_full ^ window_full ^ expected_window_full)) begin
                $display("PASS");
                $display("  Outputs: acknowledged_frames=%h, sent_frames=%h, window_empty=%b, window_full=%b",
                         acknowledged_frames, sent_frames, window_empty, window_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acknowledged_frames=%h, sent_frames=%h, window_empty=%b, window_full=%b",
                         expected_acknowledged_frames, expected_sent_frames, expected_window_empty, expected_window_full);
                $display("  Got:      acknowledged_frames=%h, sent_frames=%h, window_empty=%b, window_full=%b",
                         acknowledged_frames, sent_frames, window_empty, window_full);
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
        $dumpvars(0,ack, clk, reset, send_frame, acknowledged_frames, sent_frames, window_empty, window_full);
    end

endmodule

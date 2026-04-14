`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg send_enable;
    wire [7:0] data_out;
    wire send_ready;
    wire [3:0] window_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .send_enable(send_enable),
        .data_out(data_out),
        .send_ready(send_ready),
        .window_position(window_position)
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
        data_in = 8'h00;
        send_enable = 0;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b1, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Single Packet Transmission", test_num);
        reset_dut();
        @(posedge clk);
        data_in = 8'hA5;
        send_enable = 1;
        @(posedge clk);
        send_enable = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'hA5, 1'b1, 4'h0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("\nTestcase %03d: Filling the Window", test_num);
        reset_dut();
        for (i = 1; i <= 8; i = i + 1) begin
            @(posedge clk);
            data_in = i[7:0];
            send_enable = 1;
        end
        @(posedge clk);
        send_enable = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'h08, 1'b0, 4'h0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("\nTestcase %03d: Advancing Window with ACKs", test_num);
        reset_dut();

        for (i = 1; i <= 8; i = i + 1) begin
            @(posedge clk);
            data_in = i[7:0];
            send_enable = 1;
        end
        @(posedge clk);
        send_enable = 0;


        repeat(2) begin
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
        end
        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'h08, 1'b1, 4'h2);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("\nTestcase %03d: Block Transmission when Full", test_num);
        reset_dut();

        for (i = 1; i <= 8; i = i + 1) begin
            @(posedge clk);
            data_in = i[7:0];
            send_enable = 1;
        end
        @(posedge clk);

        data_in = 8'hFF;
        send_enable = 1;
        @(posedge clk);
        send_enable = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'h08, 1'b0, 4'h0);
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
        input [7:0] expected_data_out;
        input expected_send_ready;
        input [3:0] expected_window_position;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_send_ready === (expected_send_ready ^ send_ready ^ expected_send_ready) &&
                expected_window_position === (expected_window_position ^ window_position ^ expected_window_position)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, send_ready=%b, window_position=%h",
                         data_out, send_ready, window_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, send_ready=%b, window_position=%h",
                         expected_data_out, expected_send_ready, expected_window_position);
                $display("  Got:      data_out=%h, send_ready=%b, window_position=%h",
                         data_out, send_ready, window_position);
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
        $dumpvars(0,ack, clk, data_in, reset, send_enable, data_out, send_ready, window_position);
    end

endmodule

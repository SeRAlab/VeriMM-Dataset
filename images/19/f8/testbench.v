`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg send_enable;
    wire ack;
    wire [7:0] data_out;
    wire [3:0] window;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .send_enable(send_enable),
        .ack(ack),
        .data_out(data_out),
        .window(window)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        send_enable = 0;
        data_in = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nRunning Testcase %0d: Initial State Check", test_num);
        reset_dut();
        #1;

        #1;


        check_outputs(1'b0, 8'h00, 4'h8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nRunning Testcase %0d: Single Data Frame Transmission", test_num);
        reset_dut();

        @(posedge clk);
        data_in = 8'hA5;
        send_enable = 1;
        @(posedge clk);
        send_enable = 0;


        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, 8'hA5, 4'h7);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("\nRunning Testcase %0d: Fill Window Capacity", test_num);
        reset_dut();

        for (i = 1; i <= 8; i = i + 1) begin
            @(posedge clk);
            data_in = i;
            send_enable = 1;
            @(posedge clk);
            send_enable = 0;
            @(posedge clk);
        end

        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, 8'h08, 4'h0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("\nRunning Testcase %0d: Transmission Overflow Prevention", test_num);
        reset_dut();


        for (i = 1; i <= 10; i = i + 1) begin
            @(posedge clk);
            data_in = i;
            send_enable = 1;
            @(posedge clk);
            send_enable = 0;
            @(posedge clk);
        end

        repeat(2) @(posedge clk);



        #1;




        check_outputs(1'b1, 8'h08, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nRunning Testcase %0d: Reset and Re-transmission", test_num);


        reset_dut();
        @(posedge clk);
        data_in = 8'hFF;
        send_enable = 1;
        @(posedge clk);
        send_enable = 0;


        reset_dut();


        @(posedge clk);
        data_in = 8'h55;
        send_enable = 1;
        @(posedge clk);
        send_enable = 0;

        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, 8'h55, 4'h7);
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
        input [7:0] expected_data_out;
        input [3:0] expected_window;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_window === (expected_window ^ window ^ expected_window)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h, window=%h",
                         ack, data_out, window);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h, window=%h",
                         expected_ack, expected_data_out, expected_window);
                $display("  Got:      ack=%b, data_out=%h, window=%h",
                         ack, data_out, window);
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
        $dumpvars(0,clk, data_in, rst, send_enable, ack, data_out, window);
    end

endmodule

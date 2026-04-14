`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg rst;
    reg send_data;
    wire [3:0] next_packet;
    wire window_empty;
    wire [3:0] window_end;
    wire window_full;
    wire [3:0] window_start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_received(ack_received),
        .clk(clk),
        .rst(rst),
        .send_data(send_data),
        .next_packet(next_packet),
        .window_empty(window_empty),
        .window_end(window_end),
        .window_full(window_full),
        .window_start(window_start)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send_data = 0;
            ack_received = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b1, 4'h7, 1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Send 3 Packets", test_num);
            reset_dut();

            @(posedge clk); send_data = 1; #10; send_data = 0;
            @(posedge clk); send_data = 1; #10; send_data = 0;
            @(posedge clk); send_data = 1; #10; send_data = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h3, 1'b0, 4'h7, 1'b0, 4'h0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Fill Window (Size 8)", test_num);
            reset_dut();

            for(i=0; i<8; i=i+1) begin
                @(posedge clk); send_data = 1; #10; send_data = 0;
            end

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h8, 1'b0, 4'h7, 1'b1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Send 5, ACK 2", test_num);
            reset_dut();


            repeat(5) begin
                @(posedge clk); send_data = 1; #10; send_data = 0;
            end

            repeat(2) begin
                @(posedge clk); ack_received = 1; #10; ack_received = 0;
            end

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h5, 1'b0, 4'h9, 1'b0, 4'h2);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Wrap-around Sequence Numbers", test_num);
            reset_dut();


            for(i=0; i<12; i=i+1) begin
                @(posedge clk); send_data = 1; #10; send_data = 0;
                @(posedge clk); ack_received = 1; #10; ack_received = 0;
            end


            for(i=0; i<5; i=i+1) begin
                @(posedge clk); send_data = 1; #10; send_data = 0;
            end

            repeat(2) @(posedge clk);



            #1;




            check_outputs(4'h1, 1'b0, 4'h3, 1'b0, 4'hC);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("\nTestcase %0d: Full Cycle Empty Check", test_num);
            reset_dut();


            repeat(4) begin
                @(posedge clk); send_data = 1; #10; send_data = 0;
            end

            repeat(4) begin
                @(posedge clk); ack_received = 1; #10; ack_received = 0;
            end

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h4, 1'b1, 4'hB, 1'b0, 4'h4);
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
        input [3:0] expected_next_packet;
        input expected_window_empty;
        input [3:0] expected_window_end;
        input expected_window_full;
        input [3:0] expected_window_start;
        begin
            if (expected_next_packet === (expected_next_packet ^ next_packet ^ expected_next_packet) &&
                expected_window_empty === (expected_window_empty ^ window_empty ^ expected_window_empty) &&
                expected_window_end === (expected_window_end ^ window_end ^ expected_window_end) &&
                expected_window_full === (expected_window_full ^ window_full ^ expected_window_full) &&
                expected_window_start === (expected_window_start ^ window_start ^ expected_window_start)) begin
                $display("PASS");
                $display("  Outputs: next_packet=%h, window_empty=%b, window_end=%h, window_full=%b, window_start=%h",
                         next_packet, window_empty, window_end, window_full, window_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_packet=%h, window_empty=%b, window_end=%h, window_full=%b, window_start=%h",
                         expected_next_packet, expected_window_empty, expected_window_end, expected_window_full, expected_window_start);
                $display("  Got:      next_packet=%h, window_empty=%b, window_end=%h, window_full=%b, window_start=%h",
                         next_packet, window_empty, window_end, window_full, window_start);
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
        $dumpvars(0,ack_received, clk, rst, send_data, next_packet, window_empty, window_end, window_full, window_start);
    end

endmodule

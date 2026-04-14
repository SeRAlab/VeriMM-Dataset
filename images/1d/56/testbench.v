`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_packet;
    reg clk;
    reg rst;
    reg send_packet;
    wire [3:0] packets_sent;
    wire [3:0] window_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_packet(ack_packet),
        .clk(clk),
        .rst(rst),
        .send_packet(send_packet),
        .packets_sent(packets_sent),
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
            ack_packet = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single packet send", test_num);
            reset_dut();

            @(posedge clk);
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single packet send and acknowledge", test_num);
            reset_dut();

            @(posedge clk);
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;

            @(posedge clk);
            ack_packet = 1;
            @(posedge clk);
            ack_packet = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple packets partial ack", test_num);
            reset_dut();


            for(i=0; i<5; i=i+1) begin
                @(posedge clk);
                send_packet = 1;
                @(posedge clk);
                send_packet = 0;
            end


            for(i=0; i<3; i=i+1) begin
                @(posedge clk);
                ack_packet = 1;
                @(posedge clk);
                ack_packet = 0;
            end

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'd3, 4'd2);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill window to capacity", test_num);
            reset_dut();


            for(i=0; i<10; i=i+1) begin
                @(posedge clk);
                send_packet = 1;
                @(posedge clk);
                send_packet = 0;
            end

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd8);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full window fill and clear", test_num);
            reset_dut();


            for(i=0; i<8; i=i+1) begin
                @(posedge clk);
                send_packet = 1;
                @(posedge clk);
                send_packet = 0;
            end


            for(i=0; i<8; i=i+1) begin
                @(posedge clk);
                ack_packet = 1;
                @(posedge clk);
                ack_packet = 0;
            end

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'd8, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();

            @(posedge clk);
            send_packet = 1;
            repeat(3) @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;

            repeat(2) @(posedge clk);

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
        input [3:0] expected_packets_sent;
        input [3:0] expected_window_status;
        begin
            if (expected_packets_sent === (expected_packets_sent ^ packets_sent ^ expected_packets_sent) &&
                expected_window_status === (expected_window_status ^ window_status ^ expected_window_status)) begin
                $display("PASS");
                $display("  Outputs: packets_sent=%h, window_status=%h",
                         packets_sent, window_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packets_sent=%h, window_status=%h",
                         expected_packets_sent, expected_window_status);
                $display("  Got:      packets_sent=%h, window_status=%h",
                         packets_sent, window_status);
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
        $dumpvars(0,ack_packet, clk, rst, send_packet, packets_sent, window_status);
    end

endmodule

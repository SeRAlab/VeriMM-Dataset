`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_packet;
    wire busy;
    wire [3:0] packets_acknowledged;
    wire [3:0] packets_sent;
    wire [3:0] window_size;

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
        .busy(busy),
        .packets_acknowledged(packets_acknowledged),
        .packets_sent(packets_sent),
        .window_size(window_size)
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
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(0, 4'h0, 4'h0, 4'h8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Packet Transmission", test_num);
            reset_dut();


            send_packet = 1;
            @(posedge clk);
            #1 send_packet = 0;
            @(posedge clk);


            ack_received = 1;
            @(posedge clk);
            #1 ack_received = 0;
            @(posedge clk);


            #1;



            check_outputs(0, 4'h1, 4'h1, 4'h8);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill Window Capacity", test_num);
            reset_dut();


            repeat (8) begin
                send_packet = 1;
                @(posedge clk);
                #1 send_packet = 0;
                @(posedge clk);
            end


            #1;



            check_outputs(1, 4'h0, 4'h8, 4'h8);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Respect Window Size Limit", test_num);
            reset_dut();


            repeat (9) begin
                send_packet = 1;
                @(posedge clk);
                #1 send_packet = 0;
                @(posedge clk);
            end


            #1;



            check_outputs(1, 4'h0, 4'h8, 4'h8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sliding Window Recovery", test_num);
            reset_dut();


            repeat (8) begin
                send_packet = 1; @(posedge clk); #1 send_packet = 0; @(posedge clk);
            end


            repeat (3) begin
                ack_received = 1; @(posedge clk); #1 ack_received = 0; @(posedge clk);
            end


            repeat (2) begin
                send_packet = 1; @(posedge clk); #1 send_packet = 0; @(posedge clk);
            end




            #1;





            check_outputs(0, 4'h3, 4'hA, 4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Transmission", test_num);
            reset_dut();


            repeat (4) begin
                send_packet = 1; @(posedge clk); #1 send_packet = 0; @(posedge clk);
            end


            reset_dut();


            #1;



            check_outputs(0, 4'h0, 4'h0, 4'h8);
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
        input expected_busy;
        input [3:0] expected_packets_acknowledged;
        input [3:0] expected_packets_sent;
        input [3:0] expected_window_size;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_packets_acknowledged === (expected_packets_acknowledged ^ packets_acknowledged ^ expected_packets_acknowledged) &&
                expected_packets_sent === (expected_packets_sent ^ packets_sent ^ expected_packets_sent) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, packets_acknowledged=%h, packets_sent=%h, window_size=%h",
                         busy, packets_acknowledged, packets_sent, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, packets_acknowledged=%h, packets_sent=%h, window_size=%h",
                         expected_busy, expected_packets_acknowledged, expected_packets_sent, expected_window_size);
                $display("  Got:      busy=%b, packets_acknowledged=%h, packets_sent=%h, window_size=%h",
                         busy, packets_acknowledged, packets_sent, window_size);
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
        $dumpvars(0,ack_received, clk, reset, send_packet, busy, packets_acknowledged, packets_sent, window_size);
    end

endmodule

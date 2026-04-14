`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_packet;
    reg clk;
    reg reset;
    reg send_packet;
    wire [3:0] packets_acknowledged;
    wire [3:0] packets_sent;
    wire [3:0] window_end;
    wire [3:0] window_start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_packet(ack_packet),
        .clk(clk),
        .reset(reset),
        .send_packet(send_packet),
        .packets_acknowledged(packets_acknowledged),
        .packets_sent(packets_sent),
        .window_end(window_end),
        .window_start(window_start)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ack_packet = 0;
            send_packet = 0;
            reset = 1;
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
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 4'h7, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Send Single Packet", test_num);
            reset_dut();
            send_packet = 1;
            @(posedge clk);
            #1;
            send_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h1, 4'h7, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Send 3 and Ack 1", test_num);
            reset_dut();

            repeat(3) begin
                send_packet = 1;
                @(posedge clk);
                #1;
            end
            send_packet = 0;

            ack_packet = 1;
            @(posedge clk);
            #1;
            ack_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1, 4'h3, 4'h8, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Fill Window (8 packets)", test_num);
            reset_dut();
            repeat(8) begin
                send_packet = 1;
                @(posedge clk);
                #1;
            end
            send_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h8, 4'h7, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Overflow/Wrap-around and Full Clearance", test_num);
            reset_dut();

            repeat(8) begin
                send_packet = 1;
                @(posedge clk);
                #1;
            end
            send_packet = 0;

            repeat(8) begin
                ack_packet = 1;
                @(posedge clk);
                #1;
            end
            ack_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h8, 4'h8, 4'hF, 4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Flow Control Constraint", test_num);
            reset_dut();

            repeat(10) begin
                send_packet = 1;
                @(posedge clk);
                #1;
            end
            send_packet = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h8, 4'h7, 4'h0);
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
        input [3:0] expected_packets_acknowledged;
        input [3:0] expected_packets_sent;
        input [3:0] expected_window_end;
        input [3:0] expected_window_start;
        begin
            if (expected_packets_acknowledged === (expected_packets_acknowledged ^ packets_acknowledged ^ expected_packets_acknowledged) &&
                expected_packets_sent === (expected_packets_sent ^ packets_sent ^ expected_packets_sent) &&
                expected_window_end === (expected_window_end ^ window_end ^ expected_window_end) &&
                expected_window_start === (expected_window_start ^ window_start ^ expected_window_start)) begin
                $display("PASS");
                $display("  Outputs: packets_acknowledged=%h, packets_sent=%h, window_end=%h, window_start=%h",
                         packets_acknowledged, packets_sent, window_end, window_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packets_acknowledged=%h, packets_sent=%h, window_end=%h, window_start=%h",
                         expected_packets_acknowledged, expected_packets_sent, expected_window_end, expected_window_start);
                $display("  Got:      packets_acknowledged=%h, packets_sent=%h, window_end=%h, window_start=%h",
                         packets_acknowledged, packets_sent, window_end, window_start);
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
        $dumpvars(0,ack_packet, clk, reset, send_packet, packets_acknowledged, packets_sent, window_end, window_start);
    end

endmodule

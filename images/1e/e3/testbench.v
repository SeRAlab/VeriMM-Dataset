`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg receive_packet;
    reg reset;
    reg send_packet;
    wire can_send;
    wire [3:0] received_count;
    wire [3:0] sent_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .clk(clk),
        .receive_packet(receive_packet),
        .reset(reset),
        .send_packet(send_packet),
        .can_send(can_send),
        .received_count(received_count),
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
            send_packet = 0;
            receive_packet = 0;
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
            $display("\nTestcase %03d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Basic Send Operation", test_num);
            reset_dut();


            send_packet = 1;
            @(posedge clk);
            #1;
            send_packet = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 4'd0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Fill Window to Maximum", test_num);
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



            check_outputs(1'b0, 4'd0, 4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Slide Window after ACK", test_num);
            reset_dut();


            repeat(8) begin
                send_packet = 1;
                @(posedge clk);
                #1;
            end
            send_packet = 0;


            repeat(2) begin
                receive_packet = 1;
                @(posedge clk);
                #1;
            end
            receive_packet = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 4'd2, 4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Counter Wrap Around (4-bit)", test_num);
            reset_dut();


            repeat(16) begin
                send_packet = 1;
                receive_packet = 1;
                @(posedge clk);
                #1;
            end
            send_packet = 0;
            receive_packet = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Simultaneous Send and Receive", test_num);
            reset_dut();


            repeat(7) begin
                send_packet = 1;
                @(posedge clk);
                #1;
            end


            send_packet = 1;
            receive_packet = 1;
            @(posedge clk);
            #1;

            send_packet = 0;
            receive_packet = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 4'd1, 4'd8);
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
        input expected_can_send;
        input [3:0] expected_received_count;
        input [3:0] expected_sent_count;
        begin
            if (expected_can_send === (expected_can_send ^ can_send ^ expected_can_send) &&
                expected_received_count === (expected_received_count ^ received_count ^ expected_received_count) &&
                expected_sent_count === (expected_sent_count ^ sent_count ^ expected_sent_count)) begin
                $display("PASS");
                $display("  Outputs: can_send=%b, received_count=%h, sent_count=%h",
                         can_send, received_count, sent_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: can_send=%b, received_count=%h, sent_count=%h",
                         expected_can_send, expected_received_count, expected_sent_count);
                $display("  Got:      can_send=%b, received_count=%h, sent_count=%h",
                         can_send, received_count, sent_count);
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
        $dumpvars(0,clk, receive_packet, reset, send_packet, can_send, received_count, sent_count);
    end

endmodule

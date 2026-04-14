`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    wire [3:0] next_to_send;
    wire [3:0] sent_packets;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .next_to_send(next_to_send),
        .sent_packets(sent_packets)
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
            $display("Testcase %03d: Basic Reset and Initialization", test_num);
            reset_dut();



            #1;




            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Filling the Window (Max 4 Packets)", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1;




            #1;





            check_outputs(4'h4, 4'h4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Stall Check when Window is Full", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h4, 4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Single ACK sliding window", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5, 4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Continuous ACK Operation", test_num);
            reset_dut();
            ack = 1;
            repeat(8) @(posedge clk);
            #1;




            #1;





            check_outputs(4'h9, 4'h1);
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
        input [3:0] expected_next_to_send;
        input [3:0] expected_sent_packets;
        begin
            if (expected_next_to_send === (expected_next_to_send ^ next_to_send ^ expected_next_to_send) &&
                expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets)) begin
                $display("PASS");
                $display("  Outputs: next_to_send=%h, sent_packets=%h",
                         next_to_send, sent_packets);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_to_send=%h, sent_packets=%h",
                         expected_next_to_send, expected_sent_packets);
                $display("  Got:      next_to_send=%h, sent_packets=%h",
                         next_to_send, sent_packets);
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
        $dumpvars(0,ack, clk, reset, next_to_send, sent_packets);
    end

endmodule

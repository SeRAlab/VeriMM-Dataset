`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    wire [3:0] packets_received;
    wire [3:0] packets_sent;
    wire send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .packets_received(packets_received),
        .packets_sent(packets_sent),
        .send(send)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Partial Window Check (4 packets)", test_num);
            reset_dut();


            repeat(4) @(posedge clk);
            #2;


            #1;



            check_outputs(4'd0, 4'd4, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Full Window Check (8 packets)", test_num);
            reset_dut();


            repeat(8) @(posedge clk);
            #2;


            #1;



            check_outputs(4'd0, 4'd8, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: ACK Processing Check", test_num);
            reset_dut();


            repeat(8) @(posedge clk);


            @(negedge clk);
            ack = 1;
            repeat(2) @(posedge clk);
            ack = 0;
            #2;


            #1;



            check_outputs(4'd2, 4'd8, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %0d: Wrap-around Check", test_num);
            reset_dut();


            ack = 1;
            repeat(10) @(posedge clk);
            ack = 0;
            repeat(2) @(posedge clk);


            ack = 1;
            repeat(5) @(posedge clk);
            ack = 0;
            #2;





            #1;






            check_outputs(4'd15, 4'd1, 1'b1);
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
        input [3:0] expected_packets_received;
        input [3:0] expected_packets_sent;
        input expected_send;
        begin
            if (expected_packets_received === (expected_packets_received ^ packets_received ^ expected_packets_received) &&
                expected_packets_sent === (expected_packets_sent ^ packets_sent ^ expected_packets_sent) &&
                expected_send === (expected_send ^ send ^ expected_send)) begin
                $display("PASS");
                $display("  Outputs: packets_received=%h, packets_sent=%h, send=%b",
                         packets_received, packets_sent, send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packets_received=%h, packets_sent=%h, send=%b",
                         expected_packets_received, expected_packets_sent, expected_send);
                $display("  Got:      packets_received=%h, packets_sent=%h, send=%b",
                         packets_received, packets_sent, send);
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
        $dumpvars(0,ack, clk, rst, packets_received, packets_sent, send);
    end

endmodule

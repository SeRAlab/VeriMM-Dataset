`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    wire retransmit;
    wire [3:0] sent_packets;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .retransmit(retransmit),
        .sent_packets(sent_packets),
        .state(state)
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
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successful Transmission with ACK", test_num);
            reset_dut();



            repeat(5) @(posedge clk);


            ack = 1;
            @(posedge clk);
            ack = 0;


            repeat(2) @(posedge clk);



            #1;




            check_outputs(0, 4'h0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Timeout and Retransmission", test_num);
            reset_dut();


            repeat(2) @(posedge clk);



            repeat(15) @(posedge clk);



            #1;




            check_outputs(1, 4'hf, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Recovery after Retransmission", test_num);
            reset_dut();


            repeat(15) @(posedge clk);


            ack = 1;
            repeat(2) @(posedge clk);
            ack = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(0, 4'h0, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: System Reset during operation", test_num);
            reset_dut();


            repeat(2) @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);


            #1;



            check_outputs(0, 4'h0, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fast ACK", test_num);
            reset_dut();


            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;

            repeat(3) @(posedge clk);


            #1;



            check_outputs(0, 4'h0, 2'b00);
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
        input expected_retransmit;
        input [3:0] expected_sent_packets;
        input [1:0] expected_state;
        begin
            if (expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit) &&
                expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: retransmit=%b, sent_packets=%h, state=%h",
                         retransmit, sent_packets, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: retransmit=%b, sent_packets=%h, state=%h",
                         expected_retransmit, expected_sent_packets, expected_state);
                $display("  Got:      retransmit=%b, sent_packets=%h, state=%h",
                         retransmit, sent_packets, state);
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
        $dumpvars(0,ack, clk, rst, retransmit, sent_packets, state);
    end

endmodule

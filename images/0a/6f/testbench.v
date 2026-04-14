`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg rst;
    reg send_data;
    wire ack_out;
    wire [7:0] data_out;
    wire retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ dut (
        .ack_received(ack_received),
        .clk(clk),
        .rst(rst),
        .send_data(send_data),
        .ack_out(ack_out),
        .data_out(data_out),
        .retransmit(retransmit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack_received = 0;
            send_data = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Successful Transmission", test_num);
            reset_dut();

            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(3) @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Retransmission due to Timeout", test_num);
            reset_dut();

            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(15) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Success after Retransmission", test_num);
            reset_dut();

            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(15) @(posedge clk);


            ack_received = 1;
            @(posedge clk);
            ack_received = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State Check", test_num);
            reset_dut();


            repeat(20) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Successful Packets", test_num);
            reset_dut();


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;
            repeat(2) @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;
            repeat(2) @(posedge clk);


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;
            repeat(2) @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ Testbench");
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
        input expected_ack_out;
        input [7:0] expected_data_out;
        input expected_retransmit;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b, data_out=%h, retransmit=%b",
                         ack_out, data_out, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b, data_out=%h, retransmit=%b",
                         expected_ack_out, expected_data_out, expected_retransmit);
                $display("  Got:      ack_out=%b, data_out=%h, retransmit=%b",
                         ack_out, data_out, retransmit);
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
        $dumpvars(0,ack_received, clk, rst, send_data, ack_out, data_out, retransmit);
    end

endmodule

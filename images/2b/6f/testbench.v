`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;
    wire send;
    wire timeout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .send(send),
        .timeout(timeout)
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
        data_in = 0;
        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Single Packet Successful Transmission", test_num);
        reset_dut();

        data_in = 8'hA1;

        wait(send === 1'b1);
        repeat(2) @(posedge clk);


        ack = 1;
        @(posedge clk);
        ack = 0;


        repeat(2) @(posedge clk);


        #1;



        check_outputs(8'hA1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Timeout and Retransmission Detection", test_num);
        reset_dut();

        data_in = 8'hB2;
        wait(send === 1'b1);



        wait(timeout === 1'b1);
        @(posedge clk);


        #1;



        check_outputs(8'hB2, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    integer i;
    reg [7:0] test_data [0:4];
    begin
        test_data[0] = 8'h11; test_data[1] = 8'h22; test_data[2] = 8'h33;
        test_data[3] = 8'h44; test_data[4] = 8'h55;

        test_num = 3;
        $display("\nTestcase %0d: Multi-packet (5 Packets) Flow Control", test_num);
        reset_dut();

        for (i = 0; i < 5; i = i + 1) begin
            data_in = test_data[i];
            wait(send === 1'b1);
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
            repeat(2) @(posedge clk);
            $display("  Packet %0d (%h) acknowledged", i+1, test_data[i]);
        end


        #1;



        check_outputs(8'h55, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Successful ACK after a Timeout", test_num);
        reset_dut();

        data_in = 8'hC3;
        wait(send === 1'b1);


        wait(timeout === 1'b1);
        $display("  Timeout occurred as expected");
        repeat(2) @(posedge clk);


        ack = 1;
        @(posedge clk);
        ack = 0;

        repeat(5) @(posedge clk);


        #1;



        check_outputs(8'hC3, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: System Reset during Transmission", test_num);
        reset_dut();

        data_in = 8'hFF;
        wait(send === 1'b1);
        repeat(2) @(posedge clk);


        reset = 1;
        repeat(3) @(posedge clk);
        reset = 0;
        @(posedge clk);


        #1;



        check_outputs(8'h00, 1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stop_and_wait Testbench");
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
        input [7:0] expected_data_out;
        input expected_send;
        input expected_timeout;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_send === (expected_send ^ send ^ expected_send) &&
                expected_timeout === (expected_timeout ^ timeout ^ expected_timeout)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, send=%b, timeout=%b",
                         data_out, send, timeout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, send=%b, timeout=%b",
                         expected_data_out, expected_send, expected_timeout);
                $display("  Got:      data_out=%h, send=%b, timeout=%b",
                         data_out, send, timeout);
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
        $dumpvars(0,ack, clk, data_in, reset, data_out, send, timeout);
    end

endmodule

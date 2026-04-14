`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;
    wire retry;
    wire send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .retry(retry),
        .send(send)
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
        data_in = 8'h00;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Normal Transmission (Successful first try)", test_num);
        reset_dut();

        data_in = 8'hAA;

        wait(send == 1);
        @(posedge clk);
        #1 ack = 1;

        @(posedge clk);
        #1 ack = 0;


        #1;



        check_outputs(8'hAA, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single Retry (NACK then ACK)", test_num);
        reset_dut();

        data_in = 8'h55;
        wait(send == 1);

        @(posedge clk);
        #1 ack = 0;


        wait(retry == 1);
        @(posedge clk);
        #1 ack = 1;

        @(posedge clk);
        #1 ack = 0;

        #1;


        check_outputs(8'h55, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum Retries (3 NACKs then ACK)", test_num);
        reset_dut();

        data_in = 8'hF0;
        wait(send == 1);


        for (i = 0; i < 3; i = i + 1) begin
            @(posedge clk);
            #1 ack = 0;
            wait(retry == 1);
            @(posedge clk);
        end


        #1 ack = 1;
        @(posedge clk);
        #1 ack = 0;

        #1;


        check_outputs(8'hF0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Exceed Maximum Retries (4 NACKs - Give up)", test_num);
        reset_dut();

        data_in = 8'h0F;
        wait(send == 1);


        for (i = 0; i < 4; i = i + 1) begin
            @(posedge clk);
            #1 ack = 0;
            if (i < 3) wait(retry == 1);
            @(posedge clk);
        end


        #1;
        #1;

        check_outputs(data_out, 1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arq_system Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_retry;
        input expected_send;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_retry === (expected_retry ^ retry ^ expected_retry) &&
                expected_send === (expected_send ^ send ^ expected_send)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, retry=%b, send=%b",
                         data_out, retry, send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, retry=%b, send=%b",
                         expected_data_out, expected_retry, expected_send);
                $display("  Got:      data_out=%h, retry=%b, send=%b",
                         data_out, retry, send);
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
        $dumpvars(0,ack, clk, data_in, reset, data_out, retry, send);
    end

endmodule

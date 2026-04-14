`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [10:0] id_in;
    reg rx;
    reg tx_req;
    wire [7:0] data_out;
    wire [10:0] id_out;
    wire tx;
    wire tx_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .id_in(id_in),
        .rx(rx),
        .tx_req(tx_req),
        .data_out(data_out),
        .id_out(id_out),
        .tx(tx),
        .tx_ack(tx_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 8'h0;
            id_in = 11'h0;
            tx_req = 0;
            rx = 1;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Starting Transmission", test_num);
            reset_dut();

            data_in = 8'hA5;
            id_in = 11'h555;
            tx_req = 1;
            @(posedge clk);
            tx_req = 0;


            repeat (100) @(posedge clk);



            #1;




            check_outputs(8'h0, 11'h0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        reg [10:0] rx_id;
        reg [7:0] rx_data;
        begin
            test_num = 2;
            $display("Test Case %0d: Receiving Serial Data", test_num);
            reset_dut();

            rx_id = 11'h123;
            rx_data = 8'hBC;


            rx = 0; @(posedge clk);


            for (i = 10; i >= 0; i = i - 1) begin
                rx = rx_id[i];
                @(posedge clk);
            end


            for (i = 7; i >= 0; i = i - 1) begin
                rx = rx_data[i];
                @(posedge clk);
            end


            rx = 1;
            repeat (10) @(posedge clk);


            #1;



            check_outputs(8'hBC, 11'h123, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Idle State Check", test_num);
            reset_dut();


            repeat (20) @(posedge clk);


            #1;



            check_outputs(8'h0, 11'h0, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [10:0] expected_id_out;
        input expected_tx;
        input expected_tx_ack;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_id_out === (expected_id_out ^ id_out ^ expected_id_out) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx) &&
                expected_tx_ack === (expected_tx_ack ^ tx_ack ^ expected_tx_ack)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, id_out=%h, tx=%b, tx_ack=%b",
                         data_out, id_out, tx, tx_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, id_out=%h, tx=%b, tx_ack=%b",
                         expected_data_out, expected_id_out, expected_tx, expected_tx_ack);
                $display("  Got:      data_out=%h, id_out=%h, tx=%b, tx_ack=%b",
                         data_out, id_out, tx, tx_ack);
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
        $dumpvars(0,clk, data_in, id_in, rx, tx_req, data_out, id_out, tx, tx_ack);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg ll_dst_rdy;
    reg reset;
    reg rx_ack;
    reg [7:0] rx_data;
    reg rx_error;
    reg rx_valid;
    wire [7:0] ll_data;
    wire ll_eof;
    wire ll_error;
    wire ll_sof;
    wire ll_src_rdy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .ll_dst_rdy(ll_dst_rdy),
        .reset(reset),
        .rx_ack(rx_ack),
        .rx_data(rx_data),
        .rx_error(rx_error),
        .rx_valid(rx_valid),
        .ll_data(ll_data),
        .ll_eof(ll_eof),
        .ll_error(ll_error),
        .ll_sof(ll_sof),
        .ll_src_rdy(ll_src_rdy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            rx_data = 8'h00;
            rx_valid = 0;
            rx_error = 0;
            rx_ack = 0;
            ll_dst_rdy = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Behavior", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Start of Frame (SOF)", test_num);
            reset_dut();


            rx_valid = 1;
            rx_data = 8'hA5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 0, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Data Transfer (Post-SOF)", test_num);
            reset_dut();


            rx_valid = 1;
            rx_data = 8'h11;
            @(posedge clk);


            #1 rx_data = 8'h22;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h22, 0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: End of Frame (EOF)", test_num);
            reset_dut();


            rx_valid = 1;
            rx_data = 8'h11;
            @(posedge clk);
            #1 rx_data = 8'h22;
            @(posedge clk);
            #1 rx_valid = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h22, 1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Error Detection", test_num);
            reset_dut();

            rx_valid = 1;
            rx_data = 8'hEE;
            rx_error = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hEE, 0, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Backpressure (ll_dst_rdy=0)", test_num);
            reset_dut();

            ll_dst_rdy = 0;
            rx_valid = 1;
            rx_data = 8'hCC;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hCC, 0, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Clear Signal During Transfer", test_num);
            reset_dut();

            rx_valid = 1;
            rx_data = 8'hFF;
            @(posedge clk);
            #1 clear = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 0, 0, 0, 0);
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
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_ll_data;
        input expected_ll_eof;
        input expected_ll_error;
        input expected_ll_sof;
        input expected_ll_src_rdy;
        begin
            if (expected_ll_data === (expected_ll_data ^ ll_data ^ expected_ll_data) &&
                expected_ll_eof === (expected_ll_eof ^ ll_eof ^ expected_ll_eof) &&
                expected_ll_error === (expected_ll_error ^ ll_error ^ expected_ll_error) &&
                expected_ll_sof === (expected_ll_sof ^ ll_sof ^ expected_ll_sof) &&
                expected_ll_src_rdy === (expected_ll_src_rdy ^ ll_src_rdy ^ expected_ll_src_rdy)) begin
                $display("PASS");
                $display("  Outputs: ll_data=%h, ll_eof=%b, ll_error=%b, ll_sof=%b, ll_src_rdy=%b",
                         ll_data, ll_eof, ll_error, ll_sof, ll_src_rdy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ll_data=%h, ll_eof=%b, ll_error=%b, ll_sof=%b, ll_src_rdy=%b",
                         expected_ll_data, expected_ll_eof, expected_ll_error, expected_ll_sof, expected_ll_src_rdy);
                $display("  Got:      ll_data=%h, ll_eof=%b, ll_error=%b, ll_sof=%b, ll_src_rdy=%b",
                         ll_data, ll_eof, ll_error, ll_sof, ll_src_rdy);
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
        $dumpvars(0,clear, clk, ll_dst_rdy, reset, rx_ack, rx_data, rx_error, rx_valid, ll_data, ll_eof, ll_error, ll_sof, ll_src_rdy);
    end

endmodule

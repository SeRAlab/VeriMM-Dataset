`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg data_valid;
    reg rst;
    reg rx;
    wire data_out;
    wire data_ready;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .data_ready(data_ready),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            data_valid = 0;
            rx = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            data_in = 1;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);

            rx = 0;
            @(posedge clk);

            repeat(8) begin
                rx = 0;
                @(posedge clk);
            end

            rx = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);

            rx = 0;
            @(posedge clk);

            repeat(8) begin
                rx = 1;
                @(posedge clk);
            end

            rx = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
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
        input expected_data_out;
        input expected_data_ready;
        input expected_tx;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, data_ready=%b, tx=%b",
                         data_out, data_ready, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, data_ready=%b, tx=%b",
                         expected_data_out, expected_data_ready, expected_tx);
                $display("  Got:      data_out=%b, data_ready=%b, tx=%b",
                         data_out, data_ready, tx);
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
        $dumpvars(0,clk, data_in, data_valid, rst, rx, data_out, data_ready, tx);
    end

endmodule

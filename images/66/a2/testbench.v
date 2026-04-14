`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg ready_b;
    reg reset;
    reg [3:0] threshold;
    reg valid_a;
    wire [17:0] data_out;
    wire ready_a;
    wire valid_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .ready_b(ready_b),
        .reset(reset),
        .threshold(threshold),
        .valid_a(valid_a),
        .data_out(data_out),
        .ready_a(ready_a),
        .valid_b(valid_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_a = 0;
            ready_b = 0;
            data_in = 0;
            threshold = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            threshold = 4'd1;
            data_in = 16'h0005;
            valid_a = 1;
            ready_b = 1;
            @(posedge clk);
            #1;
            valid_a = 0;
            ready_b = 0;

            #1;


            check_outputs(18'h00005, ready_a, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            threshold = 4'd2;

            data_in = 16'h0001;
            valid_a = 1;
            ready_b = 1;
            @(posedge clk);
            #1;

            data_in = 16'h0001;
            @(posedge clk);
            #1;
            valid_a = 0;
            ready_b = 0;


            #1;



            check_outputs(18'h10002, ready_a, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            threshold = 4'd2;
            data_in = 16'hFFFF;
            valid_a = 1;
            ready_b = 1;
            @(posedge clk);
            #1;
            data_in = 16'h0002;
            @(posedge clk);
            #1;
            valid_a = 0;
            ready_b = 0;


            #1;



            check_outputs(18'h10001, ready_a, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            threshold = 4'd2;


            data_in = 16'h0010;
            valid_a = 1;
            ready_b = 1;
            @(posedge clk);
            #1;


            data_in = 16'h00FF;
            valid_a = 0;
            @(posedge clk);
            #1;


            data_in = 16'h0020;
            valid_a = 1;
            @(posedge clk);
            #1;

            valid_a = 0;
            ready_b = 0;


            #1;



            check_outputs(18'h00030, ready_a, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            threshold = 4'd2;


            data_in = 16'h0003;
            valid_a = 1;
            ready_b = 1;
            @(posedge clk);
            #1;


            data_in = 16'h0004;
            ready_b = 0;
            @(posedge clk);
            #1;


            ready_b = 1;
            data_in = 16'h0004;
            @(posedge clk);
            #1;

            valid_a = 0;
            ready_b = 0;


            #1;



            check_outputs(18'h10007, ready_a, 1'b1);
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
        input [17:0] expected_data_out;
        input expected_ready_a;
        input expected_valid_b;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready_a === (expected_ready_a ^ ready_a ^ expected_ready_a) &&
                expected_valid_b === (expected_valid_b ^ valid_b ^ expected_valid_b)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready_a=%b, valid_b=%b",
                         data_out, ready_a, valid_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready_a=%b, valid_b=%b",
                         expected_data_out, expected_ready_a, expected_valid_b);
                $display("  Got:      data_out=%h, ready_a=%b, valid_b=%b",
                         data_out, ready_a, valid_b);
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
        $dumpvars(0,clk, data_in, ready_b, reset, threshold, valid_a, data_out, ready_a, valid_b);
    end

endmodule

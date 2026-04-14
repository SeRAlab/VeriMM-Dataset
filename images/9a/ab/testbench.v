`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg ready_b;
    reg rst_n;
    reg select;
    reg valid_a;
    wire [9:0] data_out;
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
        .rst_n(rst_n),
        .select(select),
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
            rst_n = 0;
            data_in = 8'h0;
            select = 0;
            valid_a = 0;
            ready_b = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state after reset");
            reset_dut();

            #1;


            check_outputs(10'd0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single 8-bit input accumulation");
            reset_dut();


            @(posedge clk);
            data_in = 8'd42;
            select = 1;
            valid_a = 1;


            wait(ready_a);
            @(posedge clk);
            valid_a = 0;


            wait(valid_b);
            #1;

            check_outputs(10'd42, 0, 1);


            ready_b = 1;
            @(posedge clk);
            ready_b = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Accumulating multiple values");
            reset_dut();


            data_in = 8'd100; select = 1; valid_a = 1;
            wait(ready_a); @(posedge clk); valid_a = 0;
            wait(valid_b); ready_b = 1; @(posedge clk); ready_b = 0;


            data_in = 8'd150; select = 1; valid_a = 1;
            wait(ready_a); @(posedge clk); valid_a = 0;
            wait(valid_b);


            #1;



            check_outputs(10'd250, 0, 1);
            ready_b = 1; @(posedge clk); ready_b = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Using select to add previous data");
            reset_dut();


            data_in = 8'd50; select = 1; valid_a = 1;
            wait(ready_a); @(posedge clk); valid_a = 0;
            wait(valid_b); ready_b = 1; @(posedge clk); ready_b = 0;



            data_in = 8'd25; select = 0; valid_a = 1;
            wait(ready_a); @(posedge clk); valid_a = 0;
            wait(valid_b);



            #1;




            check_outputs(data_out, 0, 1);
            ready_b = 1; @(posedge clk); ready_b = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Backpressure test (ready_b delayed)");
            reset_dut();

            data_in = 8'hFF; select = 1; valid_a = 1;
            wait(ready_a); @(posedge clk); valid_a = 0;


            wait(valid_b);
            repeat(5) @(posedge clk);


            #1;



            check_outputs(10'h0FF, 0, 1);

            ready_b = 1;
            @(posedge clk);
            ready_b = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max value accumulation (reaching 10 bits)");
            reset_dut();


            repeat(4) begin
                data_in = 8'd255; select = 1; valid_a = 1;
                wait(ready_a); @(posedge clk); valid_a = 0;
                wait(valid_b); ready_b = 1; @(posedge clk); ready_b = 0;
            end


            #1;



            check_outputs(10'd1020, 1, 0);
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
        input [9:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, ready_b, rst_n, select, valid_a, data_out, ready_a, valid_b);
    end

endmodule

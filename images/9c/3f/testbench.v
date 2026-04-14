`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg ready_b;
    reg reset;
    reg valid_a;
    wire [15:0] data_out;
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
            data_in = 0;
            valid_a = 0;
            ready_b = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Basic Accumulation", test_num);
            reset_dut();



            @(posedge clk);
            ready_b = 1;


            data_in = 8'h10; valid_a = 1;
            wait(ready_a); @(posedge clk);


            data_in = 8'h20;
            wait(ready_a); @(posedge clk);


            data_in = 8'h30;
            wait(ready_a); @(posedge clk);


            data_in = 8'h40;
            wait(ready_a); @(posedge clk);

            valid_a = 0;


            repeat(5) @(posedge clk);



            #1;




            check_outputs(data_out, ready_a, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Mid-process Reset", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF; valid_a = 1;
            wait(ready_a); @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            valid_a = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Backpressure Handling", test_num);
            reset_dut();

            ready_b = 0;


            data_in = 8'h80; valid_a = 1;
            wait(ready_a); @(posedge clk);
            data_in = 8'h80;
            wait(ready_a); @(posedge clk);
            data_in = 8'h80;
            wait(ready_a); @(posedge clk);
            valid_a = 0;


            wait(valid_b);
            repeat(3) @(posedge clk);


            ready_b = 1;
            @(posedge clk);


            #1;



            check_outputs(data_out, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Max Value Accumulation", test_num);
            reset_dut();

            ready_b = 1;
            valid_a = 1;


            repeat(4) begin
                data_in = 8'hFF;
                wait(ready_a); @(posedge clk);
            end

            valid_a = 0;
            wait(valid_b);


            #1;



            check_outputs(16'h03FC, ready_a, 1'b1);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, ready_b, reset, valid_a, data_out, ready_a, valid_b);
    end

endmodule

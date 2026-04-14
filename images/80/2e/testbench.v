`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg [7:0] data_in;
    reg ready_b;
    reg rst_n;
    reg valid_a;
    wire [9:0] data_out;
    wire ready_a;
    wire serial_out;
    wire valid_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .data_in(data_in),
        .ready_b(ready_b),
        .rst_n(rst_n),
        .valid_a(valid_a),
        .data_out(data_out),
        .ready_a(ready_a),
        .serial_out(serial_out),
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
            ctrl = 0;
            data_in = 0;
            ready_b = 0;
            valid_a = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running testcase%03d: Initial State", test_num);

            #1;


            check_outputs(10'h000, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running testcase%03d: Single Accumulation", test_num);

            @(posedge clk);
            data_in = 8'h45;
            valid_a = 1;
            ctrl = 1;

            wait(ready_a);
            @(posedge clk);
            #1;
            valid_a = 0;


            #1;



            check_outputs(10'h045, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running testcase%03d: Multiple Accumulation", test_num);


            valid_a = 1; data_in = 8'h10; ctrl = 1;
            wait(ready_a); @(posedge clk); #1;


            data_in = 8'h20;
            wait(ready_a); @(posedge clk); #1;


            data_in = 8'h30;
            wait(ready_a); @(posedge clk); #1;

            valid_a = 0;
            ctrl = 0;


            #1;



            check_outputs(10'h060, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running testcase%03d: Max Capacity Check", test_num);

            valid_a = 1; ctrl = 1;
            data_in = 8'hFF; @(posedge clk); wait(ready_a); #1;
            data_in = 8'hFF; @(posedge clk); wait(ready_a); #1;
            data_in = 8'hFF; @(posedge clk); wait(ready_a); #1;
            data_in = 8'hFF; @(posedge clk); wait(ready_a); #1;

            valid_a = 0;


            #1;



            check_outputs(10'h3FC, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running testcase%03d: Serial Output Start", test_num);


            valid_a = 1; data_in = 8'hAA; ctrl = 1;
            wait(ready_a); @(posedge clk); #1;
            valid_a = 0;


            ready_b = 1;
            ctrl = 0;


            repeat(5) @(posedge clk);




            #1;





            check_outputs(10'h0AA, 1'b1, serial_out, 1'b1);
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
        input [9:0] expected_data_out;
        input expected_ready_a;
        input expected_serial_out;
        input expected_valid_b;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready_a === (expected_ready_a ^ ready_a ^ expected_ready_a) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out) &&
                expected_valid_b === (expected_valid_b ^ valid_b ^ expected_valid_b)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready_a=%b, serial_out=%b, valid_b=%b",
                         data_out, ready_a, serial_out, valid_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready_a=%b, serial_out=%b, valid_b=%b",
                         expected_data_out, expected_ready_a, expected_serial_out, expected_valid_b);
                $display("  Got:      data_out=%h, ready_a=%b, serial_out=%b, valid_b=%b",
                         data_out, ready_a, serial_out, valid_b);
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
        $dumpvars(0,clk, ctrl, data_in, ready_b, rst_n, valid_a, data_out, ready_a, serial_out, valid_b);
    end

endmodule

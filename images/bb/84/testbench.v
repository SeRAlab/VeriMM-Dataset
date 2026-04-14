`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg ena;
    reg parallel_load;
    reg reset;
    reg serial_in;
    wire [3:0] q;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .ena(ena),
        .parallel_load(parallel_load),
        .reset(reset),
        .serial_in(serial_in),
        .q(q),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ena = 0;
            parallel_load = 0;
            data_in = 4'b0000;
            serial_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load", test_num);
            reset_dut();

            parallel_load = 1;
            data_in = 4'b1011;
            ena = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0001, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single step and serial shift", test_num);
            reset_dut();

            parallel_load = 1;
            data_in = 4'b0110;
            ena = 1;
            @(posedge clk);
            #1;

            parallel_load = 0;
            serial_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0011, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple count steps", test_num);
            reset_dut();
            ena = 1;
            serial_in = 0;
            repeat(4) @(posedge clk);


            #1;

            #1;


            check_outputs(4'b0110, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: XOR logic toggle check", test_num);
            reset_dut();

            parallel_load = 1;
            data_in = 4'b1111;
            ena = 1;
            @(posedge clk);
            #1;

            parallel_load = 0;
            serial_in = 0;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;

            serial_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0110, 1'b1);
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
        input [3:0] expected_q;
        input expected_serial_out;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: q=%h, serial_out=%b",
                         q, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, serial_out=%b",
                         expected_q, expected_serial_out);
                $display("  Got:      q=%h, serial_out=%b",
                         q, serial_out);
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
        $dumpvars(0,clk, data_in, ena, parallel_load, reset, serial_in, q, serial_out);
    end

endmodule

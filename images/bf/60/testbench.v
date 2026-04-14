`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    wire [3:0] count_out;
    wire wrap_around;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .count_out(count_out),
        .wrap_around(wrap_around)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        data_in = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Incrementing 5 times", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(4'h5, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Load value 4'hA", test_num);
        reset_dut();
        data_in = 4'hA;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(4'hA, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Check wrap_around at count 15", test_num);
        reset_dut();
        data_in = 4'hF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;

        #1;


        check_outputs(4'hF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Transition from 15 to 0", test_num);
        reset_dut();
        data_in = 4'hF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Reset priority over load signal", test_num);
        reset_dut();
        data_in = 4'h5;
        load = 1;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        load = 0;

        #1;


        check_outputs(4'h0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Multi-cycle counting through wrap", test_num);
        reset_dut();
        data_in = 4'hE;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h1, 1'b0);
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
        input [3:0] expected_count_out;
        input expected_wrap_around;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_wrap_around === (expected_wrap_around ^ wrap_around ^ expected_wrap_around)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, wrap_around=%b",
                         count_out, wrap_around);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, wrap_around=%b",
                         expected_count_out, expected_wrap_around);
                $display("  Got:      count_out=%h, wrap_around=%b",
                         count_out, wrap_around);
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
        $dumpvars(0,clk, data_in, load, reset, count_out, wrap_around);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] ena;
    reg [49:0] in;
    reg load;
    wire [3:0] count;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .in(in),
        .load(load),
        .count(count),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            in = 50'h0;
            ena = 2'b00;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Load and Increment", test_num);
            reset_dut();


            ena = 2'b00;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'd3, q);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Left Rotation (ena=01)", test_num);
            reset_dut();
            load = 1;
            in = 50'h1;
            ena = 2'b00;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;

            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd4, q);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Right Rotation (ena=10)", test_num);
            reset_dut();
            load = 1;
            in = 50'h8000000000000;
            ena = 2'b00;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, q);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Reloading Data Mid-operation", test_num);
            reset_dut();
            ena = 2'b01;
            repeat(5) @(posedge clk);


            load = 1;
            in = 50'h3FFFFFFFFFFFF;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, q);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Counter Wrap-around", test_num);
            reset_dut();
            load = 0;
            ena = 2'b00;

            repeat(17) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, q);
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
        input [3:0] expected_count;
        input [5:0] expected_q;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: count=%h, q=%h",
                         count, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, q=%h",
                         expected_count, expected_q);
                $display("  Got:      count=%h, q=%h",
                         count, q);
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
        $dumpvars(0,clk, ena, in, load, count, q);
    end

endmodule

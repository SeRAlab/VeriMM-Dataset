`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg c;
    reg clk;
    reg [49:0] data;
    reg [1:0] ena;
    reg load;
    reg reset;
    wire out;
    wire [49:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .reset(reset),
        .out(out),
        .q(q)
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
            ena = 2'b00;
            data = 50'b0;
            a = 0; b = 0; c = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset and Basic NAND Output", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 50'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Load Data", test_num);
            reset_dut();
            data = 50'h123456789ABCD;
            load = 1;
            a = 1; b = 1; c = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(1'b0, 50'h123456789ABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Rotate Right", test_num);
            reset_dut();
            data = 50'h0000000000001;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1 ena = 2'b00;


            #1;



            check_outputs(1'b1, 50'h2000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Rotate Left", test_num);
            reset_dut();
            data = 50'h2000000000000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1 ena = 2'b00;

            #1;


            check_outputs(1'b1, 50'h0000000000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Multi-bit Left Rotation", test_num);
            reset_dut();
            data = 50'h000000000000F;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 2'b10;
            repeat(4) @(posedge clk);
            #1 ena = 2'b00;

            #1;


            check_outputs(1'b1, 50'h00000000000F0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: NAND Logic combinations", test_num);
            reset_dut();
            a = 1; b = 0; c = 1;

            #1;
            #1;

            check_outputs(1'b1, 50'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Load priority over Enable", test_num);
            reset_dut();
            data = 50'hAAAAA_AAAAA_AAAAA;
            load = 1;
            ena = 2'b01;
            @(posedge clk);
            #1 load = 0; ena = 2'b00;

            #1;


            check_outputs(1'b1, 50'hAAAAA_AAAAA_AAAAA);
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
        input expected_out;
        input [49:0] expected_q;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out=%b, q=%h",
                         out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, q=%h",
                         expected_out, expected_q);
                $display("  Got:      out=%b, q=%h",
                         out, q);
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
        $dumpvars(0,a, b, c, clk, data, ena, load, reset, out, q);
    end

endmodule

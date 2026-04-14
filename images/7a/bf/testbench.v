`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg [3:0] o_high0;
    reg [3:0] o_high1;
    reg [3:0] o_low0;
    reg [3:0] o_low1;
    wire [3:0] i_high0;
    wire [3:0] i_high1;
    wire [3:0] i_low0;
    wire [3:0] i_low1;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .o_high0(o_high0),
        .o_high1(o_high1),
        .o_low0(o_low0),
        .o_low1(o_low1),
        .i_high0(i_high0),
        .i_high1(i_high1),
        .i_low0(i_low0),
        .i_low1(i_low1),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk = 0;
            in = 16'h0;
            o_high1 = 4'h0;
            o_low1 = 4'h0;
            o_high0 = 4'h0;
            o_low0 = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            in = 16'h1234;
            o_high1 = 4'hA;
            o_low1  = 4'hB;
            o_high0 = 4'hC;
            o_low0  = 4'hD;


            @(posedge clk);
            #1;





            #1;






            check_outputs(4'h2, 4'h1, 4'h4, 4'h3, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            in = 16'hFFFF;
            o_high1 = 4'h0;
            o_low1  = 4'h0;
            o_high0 = 4'h0;
            o_low0  = 4'h0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 4'hF, 4'hF, 4'hF, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            in = 16'h0000;
            o_high1 = 4'hF;
            o_low1  = 4'hF;
            o_high0 = 4'hF;
            o_low0  = 4'hF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            in = 16'h5A5A;
            o_high1 = 4'h5;
            o_low1  = 4'hA;
            o_high0 = 4'h5;
            o_low0  = 4'hA;

            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA, 4'h5, 4'hA, 4'h5, 16'h5A5A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            in = 16'h8421;
            o_high1 = 4'h1;
            o_low1  = 4'h2;
            o_high0 = 4'h4;
            o_low0  = 4'h8;

            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h4, 4'h8, 4'h1, 4'h2, 16'h1248);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            in = 16'hE7BD;
            o_high1 = 4'h6;
            o_low1  = 4'h9;
            o_high0 = 4'h3;
            o_low0  = 4'hF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h7, 4'hE, 4'hD, 4'hB, 16'h693F);
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
        input [3:0] expected_i_high0;
        input [3:0] expected_i_high1;
        input [3:0] expected_i_low0;
        input [3:0] expected_i_low1;
        input [15:0] expected_out;
        begin
            if (expected_i_high0 === (expected_i_high0 ^ i_high0 ^ expected_i_high0) &&
                expected_i_high1 === (expected_i_high1 ^ i_high1 ^ expected_i_high1) &&
                expected_i_low0 === (expected_i_low0 ^ i_low0 ^ expected_i_low0) &&
                expected_i_low1 === (expected_i_low1 ^ i_low1 ^ expected_i_low1) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: i_high0=%h, i_high1=%h, i_low0=%h, i_low1=%h, out=%h",
                         i_high0, i_high1, i_low0, i_low1, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_high0=%h, i_high1=%h, i_low0=%h, i_low1=%h, out=%h",
                         expected_i_high0, expected_i_high1, expected_i_low0, expected_i_low1, expected_out);
                $display("  Got:      i_high0=%h, i_high1=%h, i_low0=%h, i_low1=%h, out=%h",
                         i_high0, i_high1, i_low0, i_low1, out);
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
        $dumpvars(0,clk, in, o_high0, o_high1, o_low0, o_low1, i_high0, i_high1, i_low0, i_low1, out);
    end

endmodule

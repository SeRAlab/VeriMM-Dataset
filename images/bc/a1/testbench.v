`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] decre_bit;
    reg decre_en;
    reg [7:0] incre_bit;
    reg incre_en;
    reg [7:0] mux;
    reg res;
    wire [8:0] incre_decre_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .decre_bit(decre_bit),
        .decre_en(decre_en),
        .incre_bit(incre_bit),
        .incre_en(incre_en),
        .mux(mux),
        .res(res),
        .incre_decre_output(incre_decre_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            res = 0;
            incre_en = 0;
            decre_en = 0;
            incre_bit = 0;
            decre_bit = 0;
            mux = 0;
            @(posedge clk);
            #1;
            res = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset", test_num);
            reset_dut();
            res = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Increment (100 + 50)", test_num);
            reset_dut();
            mux = 8'd100;
            incre_bit = 8'd50;
            incre_en = 1;
            decre_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Basic Decrement (100 - 40)", test_num);
            reset_dut();
            mux = 8'd100;
            decre_bit = 8'd40;
            incre_en = 0;
            decre_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Increment with 9-bit Carry (200 + 100)", test_num);
            reset_dut();
            mux = 8'd200;
            incre_bit = 8'd100;
            incre_en = 1;
            decre_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd300);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Decrement with Underflow (10 - 20)", test_num);
            reset_dut();
            mux = 8'd10;
            decre_bit = 8'd20;
            incre_en = 0;
            decre_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h1F6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Max Addition (255 + 255)", test_num);
            reset_dut();
            mux = 8'hFF;
            incre_bit = 8'hFF;
            incre_en = 1;
            decre_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd510);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: No Enable signals", test_num);
            reset_dut();
            mux = 8'hAA;
            incre_en = 0;
            decre_en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h000);
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
        input [8:0] expected_incre_decre_output;
        begin
            if (expected_incre_decre_output === (expected_incre_decre_output ^ incre_decre_output ^ expected_incre_decre_output)) begin
                $display("PASS");
                $display("  Outputs: incre_decre_output=%h",
                         incre_decre_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: incre_decre_output=%h",
                         expected_incre_decre_output);
                $display("  Got:      incre_decre_output=%h",
                         incre_decre_output);
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
        $dumpvars(0,clk, decre_bit, decre_en, incre_bit, incre_en, mux, res, incre_decre_output);
    end

endmodule

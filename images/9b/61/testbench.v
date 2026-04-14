`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d1;
    reg [7:0] d2;
    reg reset;
    reg select;
    wire [7:0] out_comp;
    wire [7:0] out_sum;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d1(d1),
        .d2(d2),
        .reset(reset),
        .select(select),
        .out_comp(out_comp),
        .out_sum(out_sum),
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
            d1 = 0;
            d2 = 0;
            select = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset State Verification");
            reset_dut();


            #1;



            check_outputs(8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Basic Addition (10 + 20), Select=0");
            reset_dut();
            d1 = 8'h0A;
            d2 = 8'h14;
            select = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hE1, 8'h1E, 8'h1E);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Basic Addition (10 + 20), Select=1");
            reset_dut();
            d1 = 8'h0A;
            d2 = 8'h14;
            select = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hE1, 8'h1E, 8'hE1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Overflow Addition (255 + 1)");
            reset_dut();
            d1 = 8'hFF;
            d2 = 8'h01;
            select = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Alternating Bit Patterns (0xAA + 0x55)");
            reset_dut();
            d1 = 8'hAA;
            d2 = 8'h55;
            select = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'hFF, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Dynamic Select Change");
            reset_dut();
            d1 = 8'h05;
            d2 = 8'h05;
            select = 0;
            @(posedge clk);
            #1;

            if (out_sum !== 8'h0A) $display("Intermediate Sum Check Failed");


            select = 1;
            #1;

            #1;


            check_outputs(8'hF5, 8'h0A, 8'hF5);
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
        input [7:0] expected_out_comp;
        input [7:0] expected_out_sum;
        input [7:0] expected_q;
        begin
            if (expected_out_comp === (expected_out_comp ^ out_comp ^ expected_out_comp) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out_comp=%h, out_sum=%h, q=%h",
                         out_comp, out_sum, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_comp=%h, out_sum=%h, q=%h",
                         expected_out_comp, expected_out_sum, expected_q);
                $display("  Got:      out_comp=%h, out_sum=%h, q=%h",
                         out_comp, out_sum, q);
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
        $dumpvars(0,clk, d1, d2, reset, select, out_comp, out_sum, q);
    end

endmodule

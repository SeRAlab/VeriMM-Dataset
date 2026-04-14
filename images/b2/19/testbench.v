`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input0;
    reg [7:0] input1;
    reg [7:0] input2;
    reg rst_n;
    reg [1:0] select;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input0(input0),
        .input1(input1),
        .input2(input2),
        .rst_n(rst_n),
        .select(select),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            input0 = 8'h00;
            input1 = 8'h00;
            input2 = 8'h00;
            select = 2'b00;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            $display("Reset complete.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking output immediately after reset (Counter MSB Low)", test_num);
            reset_dut();
            input0 = 8'hA5; select = 2'b00;

            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Counter MSB High, Select Input 0", test_num);
            reset_dut();
            input0 = 8'hAA;
            select = 2'b00;

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Counter MSB High, Select Input 1", test_num);
            reset_dut();
            input1 = 8'hBB;
            select = 2'b01;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Counter MSB High, Select Input 2", test_num);
            reset_dut();
            input2 = 8'hCC;
            select = 2'b10;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Counter wrap-around check (MSB returns to Low)", test_num);
            reset_dut();
            input0 = 8'hFF;
            select = 2'b00;

            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Dynamic Input Change when MSB High", test_num);
            reset_dut();
            input2 = 8'h11;
            select = 2'b10;
            repeat(4) @(posedge clk);
            #1;
            input2 = 8'h99;
            #1;
            #1;

            check_outputs(8'h99);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, input0, input1, input2, rst_n, select, out);
    end

endmodule

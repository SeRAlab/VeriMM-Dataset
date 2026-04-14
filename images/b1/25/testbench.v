`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg reset;
    reg select;
    wire high_input;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .select(select),
        .high_input(high_input),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            in = 0;
            select = 0;
            @(posedge clk);
            #1;
            reset = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select 0, Input 100 (Threshold Boundary)", test_num);
            reset_dut();
            in = 32'd100;
            select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select 1, Input 200 (Shifted)", test_num);
            reset_dut();
            in = 32'd200;
            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 99 (Below Threshold)", test_num);
            reset_dut();
            in = 32'd99;
            select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 32'd99);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select 1, Odd Input 5", test_num);
            reset_dut();
            in = 32'd5;
            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 32'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select 1, 32-bit Max Value", test_num);
            reset_dut();
            in = 32'hFFFF_FFFF;
            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'h7FFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset override", test_num);
            reset_dut();
            in = 32'h1234_5678;
            select = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'h0);
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
        input expected_high_input;
        input [31:0] expected_out;
        begin
            if (expected_high_input === (expected_high_input ^ high_input ^ expected_high_input) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: high_input=%b, out=%h",
                         high_input, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high_input=%b, out=%h",
                         expected_high_input, expected_out);
                $display("  Got:      high_input=%b, out=%h",
                         high_input, out);
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
        $dumpvars(0,clk, in, reset, select, high_input, out);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg reset;
    wire [31:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Baseline (Counter=0)", test_num);
            a = 32'd15;
            b = 32'd10;
            reset_dut();
            #1;

            check_outputs(32'd15 * 32'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 1 (Counter=1)", test_num);
            a = 32'd10;
            b = 32'd40;
            reset_dut();
            @(posedge clk); #1;
            #1;

            check_outputs(32'd10 * (32'd40 >> 1));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 4 (Counter=4)", test_num);
            a = 32'd5;
            b = 32'd256;
            reset_dut();
            repeat(4) @(posedge clk); #1;
            #1;

            check_outputs(32'd5 * (32'd256 >> 4));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Values (Counter=2)", test_num);
            a = 32'h0000FFFF;
            b = 32'd1024;
            reset_dut();
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(32'h0000FFFF * (32'd1024 >> 2));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Shift (Counter=15)", test_num);
            a = 32'd2;
            b = 32'h80000000;
            reset_dut();
            repeat(15) @(posedge clk); #1;
            #1;

            check_outputs(32'd2 * (32'h80000000 >> 15));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero check and Wrap-around (Counter=16->0)", test_num);
            a = 32'd1234;
            b = 32'd0;
            reset_dut();
            repeat(16) @(posedge clk); #1;
            #1;

            check_outputs(32'd1234 * 32'd0);
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
        input [31:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,a, b, clk, reset, product);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] adder_a;
    reg [31:0] adder_b;
    reg clk;
    reg rst_n;
    wire [31:0] adder_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adder_a(adder_a),
        .adder_b(adder_b),
        .clk(clk),
        .rst_n(rst_n),
        .adder_out(adder_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            adder_a = 0;
            adder_b = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (5 + 10)", test_num);
            reset_dut();
            adder_a = 32'd5;
            adder_b = 32'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Check (Max + 1)", test_num);
            reset_dut();
            adder_a = 32'hFFFF_FFFF;
            adder_b = 32'h0000_0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Addition", test_num);
            reset_dut();
            adder_a = 32'hABCD_EF12;
            adder_b = 32'h0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCD_EF12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Values Addition", test_num);
            reset_dut();
            adder_a = 32'h1234_5678;
            adder_b = 32'h8765_4321;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h9999_9999);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Async-like Reset during operation", test_num);
            reset_dut();
            adder_a = 32'hFFFF_FFFF;
            adder_b = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            rst_n = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_adder_out;
        begin
            if (expected_adder_out === (expected_adder_out ^ adder_out ^ expected_adder_out)) begin
                $display("PASS");
                $display("  Outputs: adder_out=%h",
                         adder_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder_out=%h",
                         expected_adder_out);
                $display("  Got:      adder_out=%h",
                         adder_out);
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
        $dumpvars(0,adder_a, adder_b, clk, rst_n, adder_out);
    end

endmodule

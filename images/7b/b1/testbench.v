`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg enable;
    wire [7:0] prod;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .enable(enable),
        .prod(prod)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable <= 0;
        a <= 0;
        b <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Enable=0 Check (Input: 4 * 4)", test_num);
        a <= 4;
        b <= 4;
        enable <= 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Multi (3 * 5)", test_num);
        a <= 3;
        b <= 5;
        enable <= 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Multi (0 * 10)", test_num);
        a <= 0;
        b <= 10;
        enable <= 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Max Value Multi (15 * 15)", test_num);
        a <= 15;
        b <= 15;
        enable <= 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hE1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Multi (12 * 8)", test_num);
        a <= 12;
        b <= 8;
        enable <= 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd96);
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
        input [7:0] expected_prod;
        begin
            if (expected_prod === (expected_prod ^ prod ^ expected_prod)) begin
                $display("PASS");
                $display("  Outputs: prod=%h",
                         prod);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prod=%h",
                         expected_prod);
                $display("  Got:      prod=%h",
                         prod);
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
        $dumpvars(0,a, b, clk, enable, prod);
    end

endmodule

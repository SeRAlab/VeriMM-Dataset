`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] A;
    reg ce;
    reg clk;
    reg rst;
    wire [20:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ce(ce),
        .clk(clk),
        .rst(rst),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ce = 0;
        A = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();

        #1;


        check_outputs(21'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Accumulation", test_num);
        reset_dut();
        ce = 1;
        A = 13'd100;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(21'd300);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clock Enable Check", test_num);
        reset_dut();
        ce = 1;
        A = 13'd50;
        @(posedge clk);
        ce = 0;
        A = 13'd1000;
        @(posedge clk);
        @(posedge clk);
        ce = 1;
        A = 13'd50;
        @(posedge clk);
        #1 #1;
 check_outputs(21'd100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large Value Accumulation", test_num);
        reset_dut();
        ce = 1;
        A = 13'h1FFF;
        repeat(100) @(posedge clk);
        #1 #1;
 check_outputs(21'd819100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset during operation", test_num);
        reset_dut();
        ce = 1;
        A = 13'd1000;
        @(posedge clk);
        @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        A = 13'd5;
        @(posedge clk);
        #1 #1;
 check_outputs(21'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Values", test_num);
        reset_dut();
        ce = 1;
        A = 13'd10; @(posedge clk);
        A = 13'd20; @(posedge clk);
        A = 13'd30; @(posedge clk);
        A = 13'd40; @(posedge clk);
        #1 #1;
 check_outputs(21'd100);
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
        input [20:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,A, ce, clk, rst, Y);
    end

endmodule

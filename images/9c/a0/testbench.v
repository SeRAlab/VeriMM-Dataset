`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg [1:0] b;
    reg ce;
    reg clk;
    reg clr;
    wire op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .op(op)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clr = 1;
        ce = 0;
        a = 0;
        b = 0;
        @(posedge clk);
        #1;
        clr = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying state after reset (0 == 0)", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Equality (a=2, b=2, ce=1)", test_num);
        reset_dut();
        a = 2'b10; b = 2'b10; ce = 1; clr = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Inequality (a=1, b=2, ce=1)", test_num);
        reset_dut();
        a = 2'b01; b = 2'b10; ce = 1; clr = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clock Enable check (maintain state when ce=0)", test_num);
        reset_dut();

        a = 2'b01; b = 2'b11; ce = 1; clr = 0;
        @(posedge clk); #1;

        a = 2'b11; b = 2'b11; ce = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clear signal priority over Enable", test_num);
        reset_dut();

        a = 2'b11; b = 2'b01; ce = 1; clr = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max value comparison (a=3, b=3)", test_num);
        reset_dut();
        a = 2'b11; b = 2'b11; ce = 1; clr = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple transitions", test_num);
        reset_dut();
        a = 2'b00; b = 2'b01; ce = 1; @(posedge clk); #1;
        a = 2'b10; b = 2'b10; ce = 1; @(posedge clk); #1;
        a = 2'b11; b = 2'b11; ce = 1; @(posedge clk); #1;
        a = 2'b11; b = 2'b00; ce = 1; @(posedge clk); #1;
        #1;

        check_outputs(1'b0);
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
        input expected_op;
        begin
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%b",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%b",
                         expected_op);
                $display("  Got:      op=%b",
                         op);
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
        $dumpvars(0,a, b, ce, clk, clr, op);
    end

endmodule

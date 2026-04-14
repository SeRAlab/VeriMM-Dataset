`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c_in;
    reg clk;
    reg racc;
    reg rapx;
    wire [15:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c_in(c_in),
        .clk(clk),
        .racc(racc),
        .rapx(rapx),
        .d(d)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic MAC (10 * 5 + 2)", test_num);

        racc = 1; rapx = 0; a = 0; b = 0; c_in = 0;
        @(posedge clk);
        #1;
        racc = 0;

        a = 16'd10; b = 16'd5; c_in = 16'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd52);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Multiplier (0 * 100 + 42)", test_num);
        racc = 1;
        @(posedge clk);
        #1;
        racc = 0;
        a = 16'd0; b = 16'd100; c_in = 16'd42;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd42);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overflow Truncation (256 * 256 + 0)", test_num);
        racc = 1;
        @(posedge clk);
        #1;
        racc = 0;
        a = 16'h0100; b = 16'h0100; c_in = 16'h0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Carry-in (1 * 1 + 65535)", test_num);
        racc = 1;
        @(posedge clk);
        #1;
        racc = 0;
        a = 16'd1; b = 16'd1; c_in = 16'hFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complex calculation (123 * 456 + 789)", test_num);
        racc = 1;
        @(posedge clk);
        #1;
        racc = 0;
        a = 16'd123; b = 16'd456; c_in = 16'd789;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hDE2D);
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
        input [15:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: d=%h",
                         d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h",
                         expected_d);
                $display("  Got:      d=%h",
                         d);
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

endmodule

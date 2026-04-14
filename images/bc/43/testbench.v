`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] amem;
    reg clk;
    reg reset;
    wire [31:0] a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amem(amem),
        .clk(clk),
        .reset(reset),
        .a(a)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Zero Input", test_num);
        reset = 1;
        clk = 0;
        amem = 32'h00000000;
        #10;
        reset = 0;
        #10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Ones Input", test_num);
        reset = 1;
        clk = 0;
        amem = 32'hFFFFFFFF;
        #10;
        reset = 0;
        #10;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Alternating Bits pattern 1", test_num);
        reset = 1;
        clk = 0;
        amem = 32'h55555555;
        #10;
        reset = 0;
        #10;
        clk = 1;
        #10;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Alternating Bits pattern 2", test_num);
        reset = 1;
        clk = 0;
        amem = 32'hAAAAAAAA;
        #10;
        reset = 0;
        #10;
        clk = 1;
        #10;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Random Hex Pattern", test_num);
        reset = 1;
        clk = 0;
        amem = 32'hDEADBEEF;
        #10;
        reset = 0;
        #10;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Sequential Counter-like value", test_num);
        reset = 1;
        clk = 0;
        amem = 32'h12345678;
        #10;
        reset = 0;
        #10;
        clk = 1;
        #10;
        #1;

        check_outputs(32'h12345678);
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
        input [31:0] expected_a;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a)) begin
                $display("PASS");
                $display("  Outputs: a=%h",
                         a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h",
                         expected_a);
                $display("  Got:      a=%h",
                         a);
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

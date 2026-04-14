`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    wire [15:0] a_out;
    wire [15:0] b_out;
    wire [15:0] c_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .a_out(a_out),
        .b_out(b_out),
        .c_out(c_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Executing Test Case %0d: All Zeros", test_num);
        a = 16'h0000; b = 16'h0000; c = 16'h0000;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Executing Test Case %0d: Small Integers", test_num);
        a = 16'd100; b = 16'd200; c = 16'd300;
        #1;

        check_outputs(16'd100, 16'd200, 16'd300);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Executing Test Case %0d: Maximum Hex Values", test_num);
        a = 16'hFFFF; b = 16'hFFFF; c = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Executing Test Case %0d: Bit Patterns (AA/55)", test_num);
        a = 16'hAAAA; b = 16'h5555; c = 16'hF0F0;
        #1;

        check_outputs(16'hAAAA, 16'h5555, 16'hF0F0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Executing Test Case %0d: Mixed Values", test_num);
        a = 16'h1234; b = 16'h8000; c = 16'h0001;
        #1;

        check_outputs(16'h1234, 16'h8000, 16'h0001);
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
        input [15:0] expected_a_out;
        input [15:0] expected_b_out;
        input [15:0] expected_c_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_out === (expected_a_out ^ a_out ^ expected_a_out) &&
                expected_b_out === (expected_b_out ^ b_out ^ expected_b_out) &&
                expected_c_out === (expected_c_out ^ c_out ^ expected_c_out)) begin
                $display("PASS");
                $display("  Outputs: a_out=%h, b_out=%h, c_out=%h",
                         a_out, b_out, c_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_out=%h, b_out=%h, c_out=%h",
                         expected_a_out, expected_b_out, expected_c_out);
                $display("  Got:      a_out=%h, b_out=%h, c_out=%h",
                         a_out, b_out, c_out);
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

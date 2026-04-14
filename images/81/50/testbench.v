`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg clk;
    reg nd;
    reg reset;
    wire [63:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .nd(nd),
        .reset(reset),
        .result(result),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive number, shift right by 4", test_num);
        reset = 1; a = 0; b = 0; nd = 0;
        @(posedge clk);
        #1; reset = 0; a = 64'h0000_0000_0000_00F0; b = 64'd4; nd = 1;
        @(posedge clk);
        #2; #1;
 check_outputs(64'h0000_0000_0000_000F, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative number, shift right (check sign extension)", test_num);
        reset = 1; a = 0; b = 0; nd = 0;
        @(posedge clk);
        #1; reset = 0; a = 64'hF000_0000_0000_0000; b = 64'd4; nd = 1;
        @(posedge clk);
        #2; #1;
 check_outputs(64'hFF00_0000_0000_0000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift by zero", test_num);
        reset = 1; a = 0; b = 0; nd = 0;
        @(posedge clk);
        #1; reset = 0; a = 64'h1234_5678_9ABC_DEF0; b = 64'd0; nd = 1;
        @(posedge clk);
        #2; #1;
 check_outputs(64'h1234_5678_9ABC_DEF0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max shift (63) on positive number", test_num);
        reset = 1; a = 0; b = 0; nd = 0;
        @(posedge clk);
        #1; reset = 0; a = 64'h7FFF_FFFF_FFFF_FFFF; b = 64'd63; nd = 1;
        @(posedge clk);
        #2; #1;
 check_outputs(64'h0000_0000_0000_0000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max shift (63) on negative number", test_num);
        reset = 1; a = 0; b = 0; nd = 0;
        @(posedge clk);
        #1; reset = 0; a = 64'h8000_0000_0000_0000; b = 64'd63; nd = 1;
        @(posedge clk);
        #2; #1;
 check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift by 32 bits", test_num);
        reset = 1; a = 0; b = 0; nd = 0;
        @(posedge clk);
        #1; reset = 0; a = 64'hAAAA_AAAA_BBBB_BBBB; b = 64'd32; nd = 1;
        @(posedge clk);
        #2; #1;
 check_outputs(64'hFFFF_FFFF_AAAA_AAAA, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Arithmetic shift on -1 (all ones)", test_num);
        reset = 1; a = 0; b = 0; nd = 0;
        @(posedge clk);
        #1; reset = 0; a = 64'hFFFF_FFFF_FFFF_FFFF; b = 64'd32; nd = 1;
        @(posedge clk);
        #2; #1;
 check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b1);
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
        input [63:0] expected_result;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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

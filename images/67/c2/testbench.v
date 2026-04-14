`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] iss;
    reg [7:0] isu;
    reg [7:0] ius;
    reg [7:0] iuu;
    wire [2:0] sgn;
    wire [2:0] unsgn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .iss(iss),
        .isu(isu),
        .ius(ius),
        .iuu(iuu),
        .sgn(sgn),
        .unsgn(unsgn)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros (Equality check)", test_num);
        iss = 8'sb0; isu = 8'sb0;
        ius = 8'b0;  iuu = 8'b0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b010, 3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Positive Less Than", test_num);
        iss = 8'sd10; isu = 8'sd20;
        ius = 8'd10;  iuu = 8'd20;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b001, 3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: MSB set (Signed -1 vs Unsigned 255)", test_num);

        iss = 8'hFF; isu = 8'h01;
        ius = 8'hFF; iuu = 8'h01;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b001, 3'b100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Signed Minimum vs Positive", test_num);
        iss = 8'h80; isu = 8'h7F;
        ius = 8'h80; iuu = 8'h7F;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b001, 3'b100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Large Value Equality", test_num);
        iss = 8'hAA; isu = 8'hAA;
        ius = 8'hAA; iuu = 8'hAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b010, 3'b010);
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
        input [2:0] expected_sgn;
        input [2:0] expected_unsgn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sgn === (expected_sgn ^ sgn ^ expected_sgn) &&
                expected_unsgn === (expected_unsgn ^ unsgn ^ expected_unsgn)) begin
                $display("PASS");
                $display("  Outputs: sgn=%h, unsgn=%h",
                         sgn, unsgn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sgn=%h, unsgn=%h",
                         expected_sgn, expected_unsgn);
                $display("  Got:      sgn=%h, unsgn=%h",
                         sgn, unsgn);
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

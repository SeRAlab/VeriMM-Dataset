`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] left;
    reg [2:0] operation;
    reg [31:0] right;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .left(left),
        .operation(operation),
        .right(right),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test 1: Logical Right Shift - Basic");
        operation = 3'b000;
        left = 32'hF0000000;
        right = 32'd4;
        #1;

        check_outputs(32'h0F000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test 2: Logical Right Shift - Shift out all bits");
        operation = 3'b000;
        left = 32'hFFFFFFFF;
        right = 32'd32;



        #1;




        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test 3: Arithmetic Right Shift - Sign Extension (Negative)");
        operation = 3'b001;
        left = 32'h80000000;
        right = 32'd1;
        #1;

        check_outputs(32'hC0000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test 4: Arithmetic Right Shift - Positive Value");
        operation = 3'b001;
        left = 32'h70000000;
        right = 32'd4;
        #1;

        check_outputs(32'h07000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test 5: Signed Comparison - Negative < Positive");
        operation = 3'b010;
        left = 32'hFFFFFFFF;
        right = 32'h00000001;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test 6: Signed Comparison - Negative < More Negative");
        operation = 3'b010;
        left = 32'hFFFFFFFE;
        right = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test 7: Unsigned Comparison - Large Unsigned vs Small");
        operation = 3'b011;
        left = 32'hFFFFFFFF;
        right = 32'h00000001;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test 8: Unsigned Comparison - Small vs Large");
        operation = 3'b011;
        left = 32'h0000000F;
        right = 32'h000000F0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test 9: Logical Right Shift - Fill with zeros");
        operation = 3'b000;
        left = 32'hAAAAAAAA;
        right = 32'd2;
        #1;

        check_outputs(32'h2AAAAAAA);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test 10: Signed Comparison - Equality");
        operation = 3'b010;
        left = 32'h12345678;
        right = 32'h12345678;
        #1;

        check_outputs(32'h00000000);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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

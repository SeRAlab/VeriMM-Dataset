`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] ctrlInput;
    wire [31:0] aluResult;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctrlInput(ctrlInput),
        .aluResult(aluResult),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pass Through 'a'", test_num);
        a = 32'sd12345;
        b = 32'sd6789;
        ctrlInput = 3'b000;
        #1;

        check_outputs(32'sd12345, 1'b0);

        test_num = test_num + 1;
        $display("Test Case %0d: Pass Through 'a' (Zero Result)", test_num);
        a = 32'sd0;
        b = 32'sd999;
        ctrlInput = 3'b000;
        #1;

        check_outputs(32'sd0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND", test_num);
        a = 32'hAAAA_5555;
        b = 32'hFFFF_0000;
        ctrlInput = 3'b001;
        #1;

        check_outputs(32'hAAAA_0000, 1'b0);

        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND (Zero Result)", test_num);
        a = 32'hF0F0_F0F0;
        b = 32'h0F0F_0F0F;
        ctrlInput = 3'b001;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR", test_num);
        a = 32'h1234_0000;
        b = 32'h0000_5678;
        ctrlInput = 3'b010;
        #1;

        check_outputs(32'h1234_5678, 1'b0);

        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR (Zero Result)", test_num);
        a = 32'h0;
        b = 32'h0;
        ctrlInput = 3'b010;
        #1;

        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Absolute Value (Positive Input)", test_num);
        a = 32'sd500;
        b = 32'sd0;
        ctrlInput = 3'b011;
        #1;

        check_outputs(32'sd500, 1'b0);

        test_num = test_num + 1;
        $display("Test Case %0d: Absolute Value (Negative Input)", test_num);
        a = -32'sd1000;
        b = 32'sd0;
        ctrlInput = 3'b011;
        #1;

        check_outputs(32'sd1000, 1'b0);

        test_num = test_num + 1;
        $display("Test Case %0d: Absolute Value (Zero Input)", test_num);
        a = 32'sd0;
        b = 32'sd0;
        ctrlInput = 3'b011;
        #1;

        check_outputs(32'sd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (Positive)", test_num);
        a = 32'sd100;
        b = 32'sd250;
        ctrlInput = 3'b100;
        #1;

        check_outputs(32'sd350, 1'b0);

        test_num = test_num + 1;
        $display("Test Case %0d: Addition (Result Zero)", test_num);
        a = 32'sd50;
        b = -32'sd50;
        ctrlInput = 3'b100;
        #1;

        check_outputs(32'sd0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction", test_num);
        a = 32'sd1000;
        b = 32'sd300;
        ctrlInput = 3'b101;
        #1;

        check_outputs(32'sd700, 1'b0);

        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (Result Zero)", test_num);
        a = 32'sd99;
        b = 32'sd99;
        ctrlInput = 3'b101;
        #1;

        check_outputs(32'sd0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Increment 'a'", test_num);
        a = 32'sd10;
        b = 32'sd0;
        ctrlInput = 3'b110;
        #1;

        check_outputs(32'sd11, 1'b0);

        test_num = test_num + 1;
        $display("Test Case %0d: Increment 'a' (Result Zero)", test_num);
        a = -32'sd1;
        b = 32'sd0;
        ctrlInput = 3'b110;
        #1;

        check_outputs(32'sd0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Compare (a < b)", test_num);
        a = -32'sd10;
        b = 32'sd5;
        ctrlInput = 3'b111;
        #1;

        check_outputs(32'sd1, 1'b0);

        test_num = test_num + 1;
        $display("Test Case %0d: Compare (a > b)", test_num);
        a = 32'sd20;
        b = 32'sd10;
        ctrlInput = 3'b111;
        #1;

        check_outputs(32'sd0, 1'b1);
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
        input [31:0] expected_aluResult;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluResult === (expected_aluResult ^ aluResult ^ expected_aluResult) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: aluResult=%h, zero=%b",
                         aluResult, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluResult=%h, zero=%b",
                         expected_aluResult, expected_zero);
                $display("  Got:      aluResult=%h, zero=%b",
                         aluResult, zero);
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

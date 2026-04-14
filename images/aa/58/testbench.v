`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [2:0] alu_control;
    reg [15:0] b;
    wire [15:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .alu_control(alu_control),
        .b(b),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (Normal)", test_num);
            a = 16'h1234;
            b = 16'h1111;
            alu_control = 3'b000;
            #1;

            check_outputs(16'h2345, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (Zero Flag)", test_num);
            a = 16'hFFFF;
            b = 16'h0001;
            alu_control = 3'b000;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (Normal)", test_num);
            a = 16'h000A;
            b = 16'h0003;
            alu_control = 3'b001;
            #1;

            check_outputs(16'h0007, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (Zero Flag)", test_num);
            a = 16'h5555;
            b = 16'h5555;
            alu_control = 3'b001;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise AND", test_num);
            a = 16'hF0F0;
            b = 16'hAAAA;
            alu_control = 3'b010;
            #1;

            check_outputs(16'hA0A0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise AND (Zero Flag)", test_num);
            a = 16'hF0F0;
            b = 16'h0F0F;
            alu_control = 3'b010;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise OR", test_num);
            a = 16'h1234;
            b = 16'h4321;
            alu_control = 3'b011;
            #1;

            check_outputs(16'h5375, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Comparison (True)", test_num);
            a = 16'h0001;
            b = 16'h0002;
            alu_control = 3'b100;
            #1;

            check_outputs(16'h0001, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Comparison (False/Zero)", test_num);
            a = 16'h0005;
            b = 16'h0002;
            alu_control = 3'b100;
            #1;

            check_outputs(16'h0000, 1'b1);
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
        input [15:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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

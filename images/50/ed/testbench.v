`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUControl;
    reg [63:0] a;
    reg [63:0] b;
    wire [63:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUControl(ALUControl),
        .a(a),
        .b(b),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Positive)", test_num);
            ALUControl = 4'b0010;
            a = 64'd100;
            b = 64'd250;
            #1;

            check_outputs(64'd350, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Positive Result)", test_num);
            ALUControl = 4'b0110;
            a = 64'd500;
            b = 64'd150;
            #1;

            check_outputs(64'd350, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            ALUControl = 4'b0000;
            a = 64'hAAAA_AAAA_AAAA_AAAA;
            b = 64'hFFFF_0000_FFFF_0000;
            #1;

            check_outputs(64'hAAAA_0000_AAAA_0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            ALUControl = 4'b0001;
            a = 64'h5555_5555_5555_5555;
            b = 64'h0000_FFFF_0000_FFFF;
            #1;

            check_outputs(64'h5555_FFFF_5555_FFFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Flag Check (Sub)", test_num);
            ALUControl = 4'b0110;
            a = 64'h1234_5678_9ABC_DEF0;
            b = 64'h1234_5678_9ABC_DEF0;
            #1;

            check_outputs(64'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default Case (Undefined Op -> Add)", test_num);
            ALUControl = 4'b1111;
            a = 64'd10;
            b = 64'd20;
            #1;

            check_outputs(64'd30, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 64-bit Wrap-around Addition", test_num);
            ALUControl = 4'b0010;
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'h1;
            #1;

            check_outputs(64'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Negative Result)", test_num);
            ALUControl = 4'b0110;
            a = 64'd10;
            b = 64'd20;

            #1;


            check_outputs(64'hFFFF_FFFF_FFFF_FFF6, 1'b0);
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
        input [63:0] expected_result;
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

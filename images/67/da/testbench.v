`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] aluCtr;
    reg [31:0] input1;
    reg [31:0] input2;
    wire [31:0] aluRes;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluCtr(aluCtr),
        .input1(input1),
        .input2(input2),
        .aluRes(aluRes),
        .zero(zero)
    );
    task testcase001;

        begin
            $display("Test Case 001: Bitwise AND");
            test_num = test_num + 1;
            aluCtr = 4'b0000;
            input1 = 32'hAAAA_5555;
            input2 = 32'hFFFF_0000;
            #1;

            check_outputs(32'hAAAA_0000, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Bitwise OR");
            test_num = test_num + 1;
            aluCtr = 4'b0001;
            input1 = 32'h1234_5678;
            input2 = 32'h8765_4321;
            #1;

            check_outputs(32'h9775_5779, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Addition");
            test_num = test_num + 1;
            aluCtr = 4'b0010;
            input1 = 32'd100;
            input2 = 32'd250;
            #1;

            check_outputs(32'd350, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Addition Wrap-around");
            test_num = test_num + 1;
            aluCtr = 4'b0010;
            input1 = 32'hFFFF_FFFF;
            input2 = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Subtraction (Positive Result)");
            test_num = test_num + 1;
            aluCtr = 4'b0110;
            input1 = 32'd500;
            input2 = 32'd150;
            #1;

            check_outputs(32'd350, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Subtraction (Zero Result)");
            test_num = test_num + 1;
            aluCtr = 4'b0110;
            input1 = 32'hCAFE_BABE;
            input2 = 32'hCAFE_BABE;
            #1;

            check_outputs(32'h0000_0000, 1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Subtraction (Negative Result)");
            test_num = test_num + 1;
            aluCtr = 4'b0110;
            input1 = 32'd10;
            input2 = 32'd20;
            #1;

            check_outputs(32'hFFFF_FFF6, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: SLT (10 < 20)");
            test_num = test_num + 1;
            aluCtr = 4'b0111;
            input1 = 32'd10;
            input2 = 32'd20;
            #1;

            check_outputs(32'd1, 0);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: SLT (20 < 10)");
            test_num = test_num + 1;
            aluCtr = 4'b0111;
            input1 = 32'd20;
            input2 = 32'd10;
            #1;

            check_outputs(32'd0, 1);
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
        input [31:0] expected_aluRes;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluRes === (expected_aluRes ^ aluRes ^ expected_aluRes) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: aluRes=%h, zero=%b",
                         aluRes, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluRes=%h, zero=%b",
                         expected_aluRes, expected_zero);
                $display("  Got:      aluRes=%h, zero=%b",
                         aluRes, zero);
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

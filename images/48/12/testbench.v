`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUControl;
    reg [31:0] SrcA;
    reg [31:0] SrcB;
    wire [31:0] ALUResult;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUControl(ALUControl),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Positive + Positive)", test_num);
            ALUControl = 3'd0;
            SrcA = 32'sd15;
            SrcB = 32'sd25;
            #1;

            check_outputs(32'sd40, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Zero Result)", test_num);
            ALUControl = 3'd0;
            SrcA = 32'sd100;
            SrcB = -32'sd100;
            #1;

            check_outputs(32'sd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Positive - Negative)", test_num);
            ALUControl = 3'd1;
            SrcA = 32'sd10;
            SrcB = -32'sd5;
            #1;

            check_outputs(32'sd15, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Zero Result)", test_num);
            ALUControl = 3'd1;
            SrcA = 32'sd500;
            SrcB = 32'sd500;
            #1;

            check_outputs(32'sd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical AND", test_num);
            ALUControl = 3'd2;
            SrcA = 32'hAAAA_FFFF;
            SrcB = 32'h5555_FFFF;
            #1;

            check_outputs(32'h0000_FFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical OR", test_num);
            ALUControl = 3'd4;
            SrcA = 32'hF0F0_0000;
            SrcB = 32'h0F0F_0000;
            #1;

            check_outputs(32'hFFFF_0000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND with Negation (SrcA & ~SrcB)", test_num);
            ALUControl = 3'd5;
            SrcA = 32'hFFFF_FFFF;
            SrcB = 32'h0000_FFFF;
            #1;

            check_outputs(32'hFFFF_0000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: OR with Negation (SrcA | ~SrcB)", test_num);
            ALUControl = 3'd6;
            SrcA = 32'h0000_0000;
            SrcB = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set Less Than (True: -10 < 10)", test_num);
            ALUControl = 3'd7;
            SrcA = -32'sd10;
            SrcB = 32'sd10;
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set Less Than (False: 10 < -10)", test_num);
            ALUControl = 3'd7;
            SrcA = 32'sd10;
            SrcB = -32'sd10;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set Less Than (False: Equality)", test_num);
            ALUControl = 3'd7;
            SrcA = 32'sd42;
            SrcB = 32'sd42;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid Control Signal", test_num);
            ALUControl = 3'd3;
            SrcA = 32'sd1;
            SrcB = 32'sd1;
            #1;

            check_outputs(32'hx, 1'bx);
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
        testcase011();
        testcase012();
        
        
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
        input [31:0] expected_ALUResult;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUResult === (expected_ALUResult ^ ALUResult ^ expected_ALUResult) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: ALUResult=%h, Zero=%b",
                         ALUResult, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUResult=%h, Zero=%b",
                         expected_ALUResult, expected_Zero);
                $display("  Got:      ALUResult=%h, Zero=%b",
                         ALUResult, Zero);
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

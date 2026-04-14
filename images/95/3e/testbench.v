`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] DATA1;
    reg [7:0] DATA2;
    reg [2:0] SELECT;
    wire [7:0] RESULT;
    wire ZERO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA1(DATA1),
        .DATA2(DATA2),
        .SELECT(SELECT),
        .RESULT(RESULT),
        .ZERO(ZERO)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Pass-through DATA2 (Select 0)", test_num);
            DATA1 = 8'h55;
            DATA2 = 8'hAA;
            SELECT = 3'b000;
            #1;

            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Pass-through DATA2 Zero (Select 0)", test_num);
            DATA1 = 8'hFF;
            DATA2 = 8'h00;
            SELECT = 3'b000;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Addition (Select 1)", test_num);
            DATA1 = 8'h10;
            DATA2 = 8'h20;
            SELECT = 3'b001;
            #1;

            check_outputs(8'h30, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Addition Overflow to Zero (Select 1)", test_num);
            DATA1 = 8'hFF;
            DATA2 = 8'h01;
            SELECT = 3'b001;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Bitwise AND (Select 2)", test_num);
            DATA1 = 8'hF0;
            DATA2 = 8'hA5;
            SELECT = 3'b010;
            #1;

            check_outputs(8'hA0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bitwise AND Zero Result (Select 2)", test_num);
            DATA1 = 8'hAA;
            DATA2 = 8'h55;
            SELECT = 3'b010;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bitwise OR (Select 3)", test_num);
            DATA1 = 8'h50;
            DATA2 = 8'h05;
            SELECT = 3'b011;
            #1;

            check_outputs(8'h55, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Bitwise OR Zero Result (Select 3)", test_num);
            DATA1 = 8'h00;
            DATA2 = 8'h00;
            SELECT = 3'b011;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Addition Maximum Values (Select 1)", test_num);
            DATA1 = 8'hFF;
            DATA2 = 8'hFF;
            SELECT = 3'b001;
            #1;

            check_outputs(8'hFE, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Pass-through DATA2 Random (Select 0)", test_num);
            DATA1 = 8'h12;
            DATA2 = 8'h34;
            SELECT = 3'b000;
            #1;

            check_outputs(8'h34, 1'b0);
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
        input [7:0] expected_RESULT;
        input expected_ZERO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT) &&
                expected_ZERO === (expected_ZERO ^ ZERO ^ expected_ZERO)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h, ZERO=%b",
                         RESULT, ZERO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h, ZERO=%b",
                         expected_RESULT, expected_ZERO);
                $display("  Got:      RESULT=%h, ZERO=%b",
                         RESULT, ZERO);
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

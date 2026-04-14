`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] operand1;
    reg [31:0] operand2;
    reg [1:0] sel;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .operand1(operand1),
        .operand2(operand2),
        .sel(sel),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            sel = 2'b00;
            operand1 = 32'h3F800000;
            operand2 = 32'h3F800000;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            sel = 2'b00;
            operand1 = 32'h40100000;
            operand2 = 32'h3FC00000;
            #1;

            check_outputs(32'h40700000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            sel = 2'b01;
            operand1 = 32'h40A00000;
            operand2 = 32'h40000000;
            #1;

            check_outputs(32'h40400000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            sel = 2'b01;
            operand1 = 32'h3F800000;
            operand2 = 32'h3F800000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            sel = 2'b10;
            operand1 = 32'h40000000;
            operand2 = 32'h40400000;
            #1;

            check_outputs(32'h40C00000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            sel = 2'b10;
            operand1 = 32'hC0200000;
            operand2 = 32'h40800000;
            #1;

            check_outputs(32'hC1200000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            sel = 2'b11;
            operand1 = 32'h41200000;
            operand2 = 32'h40000000;
            #1;

            check_outputs(32'h40A00000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            sel = 2'b11;
            operand1 = 32'h3F800000;
            operand2 = 32'h40000000;
            #1;

            check_outputs(32'h3F000000);
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

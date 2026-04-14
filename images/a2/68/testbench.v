`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] Operation;
    reg [31:0] regData1;
    reg [31:0] regData2;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Operation(Operation),
        .regData1(regData1),
        .regData2(regData2),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            Operation = 4'd0;
            regData1 = 32'h00000010;
            regData2 = 32'h00000020;
            $display("Test Case %0d: Addition (16 + 32)", test_num);
            #1;

            check_outputs(32'h00000030);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            Operation = 4'd1;
            regData1 = 32'h00000050;
            regData2 = 32'h00000010;
            $display("Test Case %0d: Subtraction (80 - 16)", test_num);
            #1;

            check_outputs(32'h00000040);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            Operation = 4'd2;
            regData1 = 32'hF0F0F0F0;
            regData2 = 32'hAAAAAAA0;
            $display("Test Case %0d: Bitwise AND", test_num);
            #1;

            check_outputs(32'hA0A0A0A0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            Operation = 4'd3;
            regData1 = 32'hF0F0F0F0;
            regData2 = 32'h0F0F0F0F;
            $display("Test Case %0d: Bitwise OR", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            Operation = 4'd4;
            regData1 = 32'hAAAAAAAA;
            regData2 = 32'h55555555;
            $display("Test Case %0d: Bitwise XOR", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            Operation = 4'd5;
            regData1 = 32'h0000FFFF;
            regData2 = 32'h00000000;
            $display("Test Case %0d: Bitwise NOT (~0x0000FFFF)", test_num);
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            Operation = 4'd6;
            regData1 = 32'h00000001;
            regData2 = 32'h00000004;
            $display("Test Case %0d: Logical Shift Left (1 << 4)", test_num);
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            Operation = 4'd7;
            regData1 = 32'h80000000;
            regData2 = 32'h00000001;
            $display("Test Case %0d: Logical Shift Right (MSB 1 >> 1)", test_num);
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            Operation = 4'd8;
            regData1 = 32'h80000000;
            regData2 = 32'h00000001;
            $display("Test Case %0d: Arithmetic Shift Right (MSB 1 sign extend)", test_num);
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            Operation = 4'd15;
            regData1 = 32'hFFFFFFFF;
            regData2 = 32'hFFFFFFFF;
            $display("Test Case %0d: Default Case (Op 15)", test_num);
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

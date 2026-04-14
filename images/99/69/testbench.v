`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] OperandA;
    wire [15:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OperandA(OperandA),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            OperandA = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: All Ones", test_num);
            OperandA = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Alternating Bits (5555)", test_num);
            OperandA = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Alternating Bits (AAAA)", test_num);
            OperandA = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Least Significant Bit", test_num);
            OperandA = 16'h0001;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Most Significant Bit", test_num);
            OperandA = 16'h8000;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Hex Pattern 1234", test_num);
            OperandA = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Hex Pattern ABCD", test_num);
            OperandA = 16'hABCD;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Hex Pattern DEAD", test_num);
            OperandA = 16'hDEAD;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Hex Pattern BEEF", test_num);
            OperandA = 16'hBEEF;
            #1;

            check_outputs(16'hBEEF);
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
        input [15:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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

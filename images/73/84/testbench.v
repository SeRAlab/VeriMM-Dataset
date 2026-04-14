`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Op1;
    reg Op2;
    wire Res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Op1(Op1),
        .Op2(Op2),
        .Res(Res)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Op1=0, Op2=0 (Expected Res=0)");
            Op1 = 1'b0;
            Op2 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Op1=0, Op2=1 (Expected Res=1)");
            Op1 = 1'b0;
            Op2 = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Op1=1, Op2=0 (Expected Res=1)");
            Op1 = 1'b1;
            Op2 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Op1=1, Op2=1 (Expected Res=0)");
            Op1 = 1'b1;
            Op2 = 1'b1;
            #1;

            check_outputs(1'b0);
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
        input expected_Res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Res === (expected_Res ^ Res ^ expected_Res)) begin
                $display("PASS");
                $display("  Outputs: Res=%b",
                         Res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Res=%b",
                         expected_Res);
                $display("  Got:      Res=%b",
                         Res);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg regWrite;
    reg saidaOverflowModule;
    wire saidaMuxOverflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .regWrite(regWrite),
        .saidaOverflowModule(saidaOverflowModule),
        .saidaMuxOverflow(saidaMuxOverflow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No overflow, regWrite LOW", test_num);
            regWrite = 1'b0;
            saidaOverflowModule = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No overflow, regWrite HIGH", test_num);
            regWrite = 1'b1;
            saidaOverflowModule = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow detected, regWrite LOW", test_num);
            regWrite = 1'b0;
            saidaOverflowModule = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow detected, regWrite HIGH (Write block)", test_num);
            regWrite = 1'b1;
            saidaOverflowModule = 1'b1;
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
        input expected_saidaMuxOverflow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_saidaMuxOverflow === (expected_saidaMuxOverflow ^ saidaMuxOverflow ^ expected_saidaMuxOverflow)) begin
                $display("PASS");
                $display("  Outputs: saidaMuxOverflow=%b",
                         saidaMuxOverflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saidaMuxOverflow=%b",
                         expected_saidaMuxOverflow);
                $display("  Got:      saidaMuxOverflow=%b",
                         saidaMuxOverflow);
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

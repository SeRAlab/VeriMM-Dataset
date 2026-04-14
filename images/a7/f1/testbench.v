`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire clockSignal;
    wire reg_mem_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clockSignal(clockSignal),
        .reg_mem_clk(reg_mem_clk)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking Initial State", test_num);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking clockSignal first toggle (High)", test_num);
            #49;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking reg_mem_clk delayed update (High)", test_num);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking clockSignal second toggle (Low)", test_num);
            #46;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking reg_mem_clk delayed update (Low)", test_num);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying continuous clockSignal toggle (High)", test_num);
            #46;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_clockSignal;
        input expected_reg_mem_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clockSignal === (expected_clockSignal ^ clockSignal ^ expected_clockSignal) &&
                expected_reg_mem_clk === (expected_reg_mem_clk ^ reg_mem_clk ^ expected_reg_mem_clk)) begin
                $display("PASS");
                $display("  Outputs: clockSignal=%b, reg_mem_clk=%b",
                         clockSignal, reg_mem_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clockSignal=%b, reg_mem_clk=%b",
                         expected_clockSignal, expected_reg_mem_clk);
                $display("  Got:      clockSignal=%b, reg_mem_clk=%b",
                         clockSignal, reg_mem_clk);
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

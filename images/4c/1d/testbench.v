`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] f;
    wire [9:0] or_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .f(f),
        .or_result(or_result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input f = 10'h000 (Check result matches constant 10'h2A2)", test_num);
        f = 10'h000;
        #1;

        check_outputs(10'h2A2);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input f = 10'h3FF (Check all ones)", test_num);
        f = 10'h3FF;
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input f = 10'h2A2 (Input matches constant)", test_num);
        f = 10'h2A2;
        #1;

        check_outputs(10'h2A2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input f = 10'h15D (Complement of constant, result should be 3FF)", test_num);
        f = 10'h15D;
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input f = 10'h055 (Arbitrary value)", test_num);
        f = 10'h055;

        #1;


        check_outputs(10'h2F7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input f = 10'h101 (Set MSB bit group)", test_num);
        f = 10'h101;

        #1;


        check_outputs(10'h3A3);
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
        input [9:0] expected_or_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_or_result === (expected_or_result ^ or_result ^ expected_or_result)) begin
                $display("PASS");
                $display("  Outputs: or_result=%h",
                         or_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: or_result=%h",
                         expected_or_result);
                $display("  Got:      or_result=%h",
                         or_result);
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

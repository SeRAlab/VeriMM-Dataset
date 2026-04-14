`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg active;
    reg clk;
    wire clk_gated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .active(active),
        .clk(clk),
        .clk_gated(clk_gated)
    );
    task testcase001;

    begin
        $display("Testcase 001: Active=0 during low phase, clk_gated should stay 0");
        test_num = 1;

        clk = 0; active = 0;
        #10;

        clk = 1;
        #5;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Active=1 during low phase, clk_gated should follow clk");
        test_num = 2;

        clk = 0; active = 1;
        #10;

        clk = 1;
        #5;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Active 1->0 while clk high, output should remain high for full pulse");
        test_num = 3;

        clk = 0; active = 1;
        #10;
        clk = 1;
        #2;

        active = 0;
        #3;

        #1;


        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Active 0->1 while clk high, output should remain low until next cycle");
        test_num = 4;

        clk = 0; active = 0;
        #10;
        clk = 1;
        #2;

        active = 1;
        #3;

        #1;


        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Active high then low, checking sequence");
        test_num = 5;

        clk = 0; active = 1;
        #10;
        clk = 1;
        #10;

        clk = 0; active = 0;
        #10;
        clk = 1;
        #5;

        #1;


        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Active toggles during low phase, only last state should matter");
        test_num = 6;
        clk = 0;
        active = 0; #2;
        active = 1; #2;
        active = 0; #2;
        active = 1; #4;
        clk = 1;
        #5;
        #1;

        check_outputs(1);
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
        input expected_clk_gated;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk_gated === (expected_clk_gated ^ clk_gated ^ expected_clk_gated)) begin
                $display("PASS");
                $display("  Outputs: clk_gated=%b",
                         clk_gated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_gated=%b",
                         expected_clk_gated);
                $display("  Got:      clk_gated=%b",
                         clk_gated);
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

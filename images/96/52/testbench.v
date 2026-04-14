`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk_in;
    reg resetn;
    wire clk_50m;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .resetn(resetn),
        .clk_50m(clk_50m),
        .locked(locked)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Assert Reset", test_num);
            resetn = 0;
            #100;



            #1;




            check_outputs(clk_50m, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Deassert Reset", test_num);
            resetn = 0;
            #20;
            resetn = 1;
            #100;

            #1;


            check_outputs(clk_50m, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clock High Phase Verification", test_num);
            resetn = 1;
            @(posedge clk_50m);
            #5;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clock Low Phase Verification", test_num);
            resetn = 0; #10; resetn = 1;
            @(posedge clk_50m);
            #15;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic Reset Toggle", test_num);
            resetn = 1;
            #50;
            resetn = 0;
            #50;
            #1;

            check_outputs(clk_50m, 1'b0);
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
        input expected_clk_50m;
        input expected_locked;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk_50m === (expected_clk_50m ^ clk_50m ^ expected_clk_50m) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: clk_50m=%b, locked=%b",
                         clk_50m, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_50m=%b, locked=%b",
                         expected_clk_50m, expected_locked);
                $display("  Got:      clk_50m=%b, locked=%b",
                         clk_50m, locked);
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

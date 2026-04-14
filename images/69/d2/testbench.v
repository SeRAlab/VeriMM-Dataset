`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bistclk;
    reg clksel;
    reg l2clk;
    reg lce;
    reg se;
    wire l1clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bistclk(bistclk),
        .clksel(clksel),
        .l2clk(l2clk),
        .lce(lce),
        .se(se),
        .l1clk(l1clk)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select l2clk, Gating Disabled (lce=0, se=0)", test_num);
            clksel = 0;
            lce = 0;
            se = 0;
            l2clk = 1;
            bistclk = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select l2clk, Functional Enable High (lce=1, se=0) - Clock High", test_num);
            clksel = 0;
            lce = 1;
            se = 0;
            l2clk = 1;
            bistclk = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select l2clk, Functional Enable High (lce=1, se=0) - Clock Low", test_num);
            clksel = 0;
            lce = 1;
            se = 0;
            l2clk = 0;
            bistclk = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select l2clk, Scan Enable Override (lce=0, se=1)", test_num);
            clksel = 0;
            lce = 0;
            se = 1;
            l2clk = 1;
            bistclk = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select bistclk, Gating Disabled (lce=0, se=0)", test_num);
            clksel = 1;
            lce = 0;
            se = 0;
            l2clk = 1;
            bistclk = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select bistclk, Functional Enable High (lce=1, se=0) - Clock High", test_num);
            clksel = 1;
            lce = 1;
            se = 0;
            l2clk = 0;
            bistclk = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select bistclk, Functional Enable High (lce=1, se=0) - Clock Low", test_num);
            clksel = 1;
            lce = 1;
            se = 0;
            l2clk = 1;
            bistclk = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select bistclk, Scan Enable Override (lce=0, se=1)", test_num);
            clksel = 1;
            lce = 0;
            se = 1;
            l2clk = 0;
            bistclk = 1;
            #1;

            check_outputs(1'b1);
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
        input expected_l1clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l1clk === (expected_l1clk ^ l1clk ^ expected_l1clk)) begin
                $display("PASS");
                $display("  Outputs: l1clk=%b",
                         l1clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l1clk=%b",
                         expected_l1clk);
                $display("  Got:      l1clk=%b",
                         l1clk);
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

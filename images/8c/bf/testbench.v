`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PWRDN;
    wire CLKOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PWRDN(PWRDN),
        .CLKOUT(CLKOUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power-down check. Asserting PWRDN.", test_num);
            PWRDN = 1;
            #1000;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal operation check. Wait for first toggle.", test_num);

            PWRDN = 1;
            #100;

            PWRDN = 0;


            #(289017);
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Normal operation check. Wait for two toggles.", test_num);

            PWRDN = 1;
            #100;

            PWRDN = 0;


            #(578034);
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verification of toggle consistency (3 half-periods).", test_num);

            PWRDN = 1;
            #100;

            PWRDN = 0;


            #(867051);
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Mid-cycle power down check.", test_num);

            PWRDN = 1;
            #100;

            PWRDN = 0;

            #(289017 / 2);

            PWRDN = 1;
            #100;

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
        input expected_CLKOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CLKOUT === (expected_CLKOUT ^ CLKOUT ^ expected_CLKOUT)) begin
                $display("PASS");
                $display("  Outputs: CLKOUT=%b",
                         CLKOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLKOUT=%b",
                         expected_CLKOUT);
                $display("  Got:      CLKOUT=%b",
                         CLKOUT);
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

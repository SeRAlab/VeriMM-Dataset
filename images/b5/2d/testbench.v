`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ENA;
    wire CLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ENA(ENA),
        .CLK(CLK)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify CLK stays low when ENA is 0", test_num);

            ENA = 0;
            #100;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enable oscillation then disable", test_num);

            ENA = 0;
            #10;

            ENA = 1;
            #200;

            ENA = 0;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Long oscillation duration test", test_num);

            ENA = 0;
            #10;

            ENA = 1;
            #2000;

            ENA = 0;
            #50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Short Enable pulse and cleanup", test_num);

            ENA = 0;
            #10;

            ENA = 1;
            #15;
            ENA = 0;
            #5;
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
        input expected_CLK;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CLK === (expected_CLK ^ CLK ^ expected_CLK)) begin
                $display("PASS");
                $display("  Outputs: CLK=%b",
                         CLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLK=%b",
                         expected_CLK);
                $display("  Got:      CLK=%b",
                         CLK);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire LED_R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LED_R(LED_R)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial output check", test_num);

            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Long-term stability check", test_num);

            #500;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Final verification", test_num);
            #100;
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
        input expected_LED_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LED_R === (expected_LED_R ^ LED_R ^ expected_LED_R)) begin
                $display("PASS");
                $display("  Outputs: LED_R=%b",
                         LED_R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED_R=%b",
                         expected_LED_R);
                $display("  Got:      LED_R=%b",
                         LED_R);
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

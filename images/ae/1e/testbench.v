`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DTR;
    reg RTS;
    wire LED0;
    wire LED7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DTR(DTR),
        .RTS(RTS),
        .LED0(LED0),
        .LED7(LED7)
    );
    task testcase001;

        begin
            $display("Test Case 001: Both inputs low");
            DTR = 1'b0;
            RTS = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: DTR high, RTS low (LED0 should be high)");
            DTR = 1'b1;
            RTS = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: DTR low, RTS high (LED7 should be high)");
            DTR = 1'b0;
            RTS = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Both inputs high (Both LEDs should be high)");
            DTR = 1'b1;
            RTS = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_LED0;
        input expected_LED7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LED0 === (expected_LED0 ^ LED0 ^ expected_LED0) &&
                expected_LED7 === (expected_LED7 ^ LED7 ^ expected_LED7)) begin
                $display("PASS");
                $display("  Outputs: LED0=%b, LED7=%b",
                         LED0, LED7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED0=%b, LED7=%b",
                         expected_LED0, expected_LED7);
                $display("  Got:      LED0=%b, LED7=%b",
                         LED0, LED7);
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

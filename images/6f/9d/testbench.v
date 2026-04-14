`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [6:0] hex2;
    wire [6:0] hex6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hex2(hex2),
        .hex6(hex6)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Verifying initial constant HIGH state for all segments", test_num);

            #1;


            check_outputs(7'h7F, 7'h7F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Verifying output remains stable after time delay", test_num);
            #50;

            #1;


            check_outputs(7'h7F, 7'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Final verification of hex2 and hex6 logic levels", test_num);
            #100;
            #1;

            check_outputs(7'h7F, 7'h7F);
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
        input [6:0] expected_hex2;
        input [6:0] expected_hex6;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex2 === (expected_hex2 ^ hex2 ^ expected_hex2) &&
                expected_hex6 === (expected_hex6 ^ hex6 ^ expected_hex6)) begin
                $display("PASS");
                $display("  Outputs: hex2=%h, hex6=%h",
                         hex2, hex6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex2=%h, hex6=%h",
                         expected_hex2, expected_hex6);
                $display("  Got:      hex2=%h, hex6=%h",
                         hex2, hex6);
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

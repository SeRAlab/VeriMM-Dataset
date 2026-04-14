`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ENB;
    wire [6:0] HEX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ENB(ENB),
        .HEX(HEX)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: ENB = 0 (Display Disabled)", test_num);
            ENB = 1'b0;

            #1;


            check_outputs(7'b1111111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: ENB = 1 (Display Enabled - Custom Pattern)", test_num);
            ENB = 1'b1;


            #1;



            check_outputs(7'b0000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: ENB Transition 1 -> 0", test_num);
            ENB = 1'b1;
            #5;
            ENB = 1'b0;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Rapid Toggle ENB", test_num);
            ENB = 1'b0;
            #2;
            ENB = 1'b1;
            #2;
            #1;

            check_outputs(7'b0000000);
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
        input [6:0] expected_HEX;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HEX === (expected_HEX ^ HEX ^ expected_HEX)) begin
                $display("PASS");
                $display("  Outputs: HEX=%h",
                         HEX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HEX=%h",
                         expected_HEX);
                $display("  Got:      HEX=%h",
                         HEX);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] In1;
    wire [17:0] Out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In1(In1),
        .Out1(Out1)
    );
    task testcase001;

        begin
            $display("Test Case 001: Zero value");
            In1 = 18'h00000;
            #1;

            check_outputs(18'h00000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Maximum Positive Value (2's Complement)");
            In1 = 18'h1FFFF;
            #1;

            check_outputs(18'h1FFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Minimum Negative Value (2's Complement)");
            In1 = 18'h20000;
            #1;

            check_outputs(18'h20000);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Negative One (-1)");
            In1 = 18'h3FFFF;
            #1;

            check_outputs(18'h3FFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Alternating Bit Pattern A");
            In1 = 18'h2AAAA;
            #1;

            check_outputs(18'h2AAAA);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Alternating Bit Pattern B");
            In1 = 18'h15555;
            #1;

            check_outputs(18'h15555);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Random Bit Pattern");
            In1 = 18'h3C3C3;
            #1;

            check_outputs(18'h3C3C3);
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
        input [17:0] expected_Out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out1 === (expected_Out1 ^ Out1 ^ expected_Out1)) begin
                $display("PASS");
                $display("  Outputs: Out1=%h",
                         Out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out1=%h",
                         expected_Out1);
                $display("  Got:      Out1=%h",
                         Out1);
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

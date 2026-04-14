`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg h;
    reg [2:0] z;
    wire Z0;
    wire Z1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h(h),
        .z(z),
        .Z0(Z0),
        .Z1(Z1)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: State D (001), h=0");
            z = 3'b001; h = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: State D (001), h=1");
            z = 3'b001; h = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: State E (010), h=0");
            z = 3'b010; h = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: State E (010), h=1");
            z = 3'b010; h = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: State F (100), h=0");
            z = 3'b100; h = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: State F (100), h=1");
            z = 3'b100; h = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_Z0;
        input expected_Z1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z0 === (expected_Z0 ^ Z0 ^ expected_Z0) &&
                expected_Z1 === (expected_Z1 ^ Z1 ^ expected_Z1)) begin
                $display("PASS");
                $display("  Outputs: Z0=%b, Z1=%b",
                         Z0, Z1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z0=%b, Z1=%b",
                         expected_Z0, expected_Z1);
                $display("  Got:      Z0=%b, Z1=%b",
                         Z0, Z1);
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

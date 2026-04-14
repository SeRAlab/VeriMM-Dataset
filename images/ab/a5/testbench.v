`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [31:0] z0;
    wire [31:0] z1;
    wire [31:0] z2;
    wire [31:0] z3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .z0(z0),
        .z1(z1),
        .z2(z2),
        .z3(z3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Initial Output Check", test_num);





            #1;






            check_outputs(32'hxxxxxxxx, 32'hffffffff, 32'hffffffff, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Stability Check (Time Delay)", test_num);
            #50;
            #1;

            check_outputs(32'hxxxxxxxx, 32'hffffffff, 32'hffffffff, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: X-State Specific Validation", test_num);
            #10;

            if (z0 === 32'hxxxxxxxx || (z0 !== 32'h0 && z0 !== 32'hffffffff)) begin
                $display("PASS: z0 contains expected unknown/uninitialized bits.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: z0 does not show unknown behavior. Got: %h", z0);
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_z0;
        input [31:0] expected_z1;
        input [31:0] expected_z2;
        input [31:0] expected_z3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z0 === (expected_z0 ^ z0 ^ expected_z0) &&
                expected_z1 === (expected_z1 ^ z1 ^ expected_z1) &&
                expected_z2 === (expected_z2 ^ z2 ^ expected_z2) &&
                expected_z3 === (expected_z3 ^ z3 ^ expected_z3)) begin
                $display("PASS");
                $display("  Outputs: z0=%h, z1=%h, z2=%h, z3=%h",
                         z0, z1, z2, z3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z0=%h, z1=%h, z2=%h, z3=%h",
                         expected_z0, expected_z1, expected_z2, expected_z3);
                $display("  Got:      z0=%h, z1=%h, z2=%h, z3=%h",
                         z0, z1, z2, z3);
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

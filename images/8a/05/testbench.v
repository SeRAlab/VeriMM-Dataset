`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg R1;
    reg R2;
    wire G1;
    wire G2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .R1(R1),
        .R2(R2),
        .G1(G1),
        .G2(G2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R1=0, R2=0 (Idle)", test_num);
            R1 = 1'b0;
            R2 = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R1=0, R2=1 (Expect G1)", test_num);
            R1 = 1'b0;
            R2 = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R1=1, R2=0 (Expect G2)", test_num);
            R1 = 1'b1;
            R2 = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R1=1, R2=1 (Conflict - Both 0)", test_num);
            R1 = 1'b1;
            R2 = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transition R2 to R1", test_num);

            R1 = 1'b0; R2 = 1'b1;
            #5;

            R1 = 1'b1; R2 = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_G1;
        input expected_G2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G1 === (expected_G1 ^ G1 ^ expected_G1) &&
                expected_G2 === (expected_G2 ^ G2 ^ expected_G2)) begin
                $display("PASS");
                $display("  Outputs: G1=%b, G2=%b",
                         G1, G2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G1=%b, G2=%b",
                         expected_G1, expected_G2);
                $display("  Got:      G1=%b, G2=%b",
                         G1, G2);
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

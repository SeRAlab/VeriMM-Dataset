`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg I;
    reg S0;
    reg S1;
    wire O0;
    wire O1;
    wire O2;
    wire O3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .S0(S0),
        .S1(S1),
        .O0(O0),
        .O1(O1),
        .O2(O2),
        .O3(O3)
    );
    task testcase001;

        begin
            test_num = 1;
            S1 = 0; S0 = 0; I = 0;
            $display("Testcase %0d: S1S0=00, I=0 -> Expect O0=0, others=Z", test_num);
            #1;

            check_outputs(1'b0, 1'bz, 1'bz, 1'bz);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            S1 = 0; S0 = 0; I = 1;
            $display("Testcase %0d: S1S0=00, I=1 -> Expect O0=1, others=Z", test_num);
            #1;

            check_outputs(1'b1, 1'bz, 1'bz, 1'bz);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            S1 = 0; S0 = 1; I = 0;
            $display("Testcase %0d: S1S0=01, I=0 -> Expect O1=0, others=Z", test_num);
            #1;

            check_outputs(1'bz, 1'b0, 1'bz, 1'bz);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            S1 = 0; S0 = 1; I = 1;
            $display("Testcase %0d: S1S0=01, I=1 -> Expect O1=1, others=Z", test_num);
            #1;

            check_outputs(1'bz, 1'b1, 1'bz, 1'bz);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            S1 = 1; S0 = 0; I = 0;
            $display("Testcase %0d: S1S0=10, I=0 -> Expect O2=0, others=Z", test_num);
            #1;

            check_outputs(1'bz, 1'bz, 1'b0, 1'bz);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            S1 = 1; S0 = 0; I = 1;
            $display("Testcase %0d: S1S0=10, I=1 -> Expect O2=1, others=Z", test_num);
            #1;

            check_outputs(1'bz, 1'bz, 1'b1, 1'bz);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            S1 = 1; S0 = 1; I = 0;
            $display("Testcase %0d: S1S0=11, I=0 -> Expect O3=0, others=Z", test_num);
            #1;

            check_outputs(1'bz, 1'bz, 1'bz, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            S1 = 1; S0 = 1; I = 1;
            $display("Testcase %0d: S1S0=11, I=1 -> Expect O3=1, others=Z", test_num);
            #1;

            check_outputs(1'bz, 1'bz, 1'bz, 1'b1);
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
        testcase008();
        
        
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
        input expected_O0;
        input expected_O1;
        input expected_O2;
        input expected_O3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_O2 === (expected_O2 ^ O2 ^ expected_O2) &&
                expected_O3 === (expected_O3 ^ O3 ^ expected_O3)) begin
                $display("PASS");
                $display("  Outputs: O0=%b, O1=%b, O2=%b, O3=%b",
                         O0, O1, O2, O3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%b, O1=%b, O2=%b, O3=%b",
                         expected_O0, expected_O1, expected_O2, expected_O3);
                $display("  Got:      O0=%b, O1=%b, O2=%b, O3=%b",
                         O0, O1, O2, O3);
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

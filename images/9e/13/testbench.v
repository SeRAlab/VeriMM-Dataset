`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg A2;
    wire D0;
    wire D1;
    wire D2;
    wire D3;
    wire D4;
    wire D5;
    wire D6;
    wire D7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .D5(D5),
        .D6(D6),
        .D7(D7)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input A2A1A0 = 000 (Binary 0)", test_num);
            A2 = 0; A1 = 0; A0 = 0;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input A2A1A0 = 001 (Binary 1)", test_num);
            A2 = 0; A1 = 0; A0 = 1;
            #1;

            check_outputs(0, 1, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input A2A1A0 = 010 (Binary 2)", test_num);
            A2 = 0; A1 = 1; A0 = 0;
            #1;

            check_outputs(0, 0, 1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input A2A1A0 = 011 (Binary 3)", test_num);
            A2 = 0; A1 = 1; A0 = 1;
            #1;

            check_outputs(0, 0, 0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input A2A1A0 = 100 (Binary 4)", test_num);
            A2 = 1; A1 = 0; A0 = 0;
            #1;

            check_outputs(0, 0, 0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input A2A1A0 = 101 (Binary 5)", test_num);
            A2 = 1; A1 = 0; A0 = 1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Input A2A1A0 = 110 (Binary 6)", test_num);
            A2 = 1; A1 = 1; A0 = 0;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Input A2A1A0 = 111 (Binary 7)", test_num);
            A2 = 1; A1 = 1; A0 = 1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
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
        input expected_D0;
        input expected_D1;
        input expected_D2;
        input expected_D3;
        input expected_D4;
        input expected_D5;
        input expected_D6;
        input expected_D7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D0 === (expected_D0 ^ D0 ^ expected_D0) &&
                expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2) &&
                expected_D3 === (expected_D3 ^ D3 ^ expected_D3) &&
                expected_D4 === (expected_D4 ^ D4 ^ expected_D4) &&
                expected_D5 === (expected_D5 ^ D5 ^ expected_D5) &&
                expected_D6 === (expected_D6 ^ D6 ^ expected_D6) &&
                expected_D7 === (expected_D7 ^ D7 ^ expected_D7)) begin
                $display("PASS");
                $display("  Outputs: D0=%b, D1=%b, D2=%b, D3=%b, D4=%b, D5=%b, D6=%b, D7=%b",
                         D0, D1, D2, D3, D4, D5, D6, D7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D0=%b, D1=%b, D2=%b, D3=%b, D4=%b, D5=%b, D6=%b, D7=%b",
                         expected_D0, expected_D1, expected_D2, expected_D3, expected_D4, expected_D5, expected_D6, expected_D7);
                $display("  Got:      D0=%b, D1=%b, D2=%b, D3=%b, D4=%b, D5=%b, D6=%b, D7=%b",
                         D0, D1, D2, D3, D4, D5, D6, D7);
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

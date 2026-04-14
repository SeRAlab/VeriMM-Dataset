`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg B0;
    reg B1;
    reg C0;
    reg C1;
    reg D0;
    reg D1;
    reg S0;
    reg S1;
    wire Out0;
    wire Out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .B0(B0),
        .B1(B1),
        .C0(C0),
        .C1(C1),
        .D0(D0),
        .D1(D1),
        .S0(S0),
        .S1(S1),
        .Out0(Out0),
        .Out1(Out1)
    );
    task testcase001;

    begin
        $display("Testcase 001: Select A, Value=2'b11");
        A1 = 1; A0 = 1;
        B1 = 0; B0 = 0;
        C1 = 0; C0 = 0;
        D1 = 0; D0 = 0;
        S1 = 0; S0 = 0;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Select B, Value=2'b10");
        A1 = 0; A0 = 0;
        B1 = 1; B0 = 0;
        C1 = 1; C0 = 1;
        D1 = 1; D0 = 1;
        S1 = 0; S0 = 1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Select C, Value=2'b01");
        A1 = 1; A0 = 1;
        B1 = 1; B0 = 1;
        C1 = 0; C0 = 1;
        D1 = 0; D0 = 0;
        S1 = 1; S0 = 0;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Select D, Value=2'b00");
        A1 = 1; A0 = 1;
        B1 = 1; B0 = 1;
        C1 = 1; C0 = 1;
        D1 = 0; D0 = 0;
        S1 = 1; S0 = 1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Select A, Value=2'b01 (Testing isolation)");

        A1 = 0; A0 = 1;
        B1 = 1; B0 = 1;
        C1 = 1; C0 = 1;
        D1 = 1; D0 = 1;
        S1 = 0; S0 = 0;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Select B, Value=2'b11 (Testing isolation)");

        A1 = 0; A0 = 0;
        B1 = 1; B0 = 1;
        C1 = 0; C0 = 0;
        D1 = 0; D0 = 0;
        S1 = 0; S0 = 1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Select C, Value=2'b10 (Testing isolation)");

        A1 = 0; A0 = 1;
        B1 = 0; B0 = 1;
        C1 = 1; C0 = 0;
        D1 = 0; D0 = 1;
        S1 = 1; S0 = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Select D, Value=2'b11 (High-impedance-like check)");
        A1 = 0; A0 = 0;
        B1 = 0; B0 = 0;
        C1 = 0; C0 = 0;
        D1 = 1; D0 = 1;
        S1 = 1; S0 = 1;
        #1;

        check_outputs(1, 1);
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
        input expected_Out0;
        input expected_Out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out0 === (expected_Out0 ^ Out0 ^ expected_Out0) &&
                expected_Out1 === (expected_Out1 ^ Out1 ^ expected_Out1)) begin
                $display("PASS");
                $display("  Outputs: Out0=%b, Out1=%b",
                         Out0, Out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out0=%b, Out1=%b",
                         expected_Out0, expected_Out1);
                $display("  Got:      Out0=%b, Out1=%b",
                         Out0, Out1);
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

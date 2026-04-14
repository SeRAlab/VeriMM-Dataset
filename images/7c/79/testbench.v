`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg B1;
    reg C1;
    reg reset;
    reg [1:0] select;
    wire X;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .C1(C1),
        .reset(reset),
        .select(select),
        .X(X),
        .valid(valid)
    );
    task testcase001;

    begin
        $display("Testcase 001: Mode 00, All A inputs HIGH");
        reset = 1;
        #10;
        reset = 0;
        select = 2'b00;
        A1 = 1; A2 = 1; A3 = 1;
        B1 = 0; C1 = 0;
        #10;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Mode 00, One A input LOW");
        reset = 1;
        #10;
        reset = 0;
        select = 2'b00;
        A1 = 1; A2 = 0; A3 = 1;
        B1 = 1; C1 = 1;
        #10;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Mode 01, All target inputs (A1, B1, C1) HIGH");
        reset = 1;
        #10;
        reset = 0;
        select = 2'b01;
        A1 = 1; B1 = 1; C1 = 1;
        A2 = 0; A3 = 0;
        #10;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Mode 01, One target input (B1) LOW");
        reset = 1;
        #10;
        reset = 0;
        select = 2'b01;
        A1 = 1; B1 = 0; C1 = 1;
        A2 = 1; A3 = 1;
        #10;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Mode 10, All target inputs (A1, B1, C1) HIGH");
        reset = 1;
        #10;
        reset = 0;
        select = 2'b10;
        A1 = 1; B1 = 1; C1 = 1;
        A2 = 0; A3 = 0;
        #10;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Mode 11, All target inputs (A1, B1, C1) HIGH");
        reset = 1;
        #10;
        reset = 0;
        select = 2'b11;
        A1 = 1; B1 = 1; C1 = 1;
        A2 = 0; A3 = 0;
        #10;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Reset Override Test");
        reset = 1;
        #10;

        select = 2'b00;
        A1 = 1; A2 = 1; A3 = 1;
        #10;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Mode 11, Input A1 LOW");
        reset = 1;
        #10;
        reset = 0;
        select = 2'b11;
        A1 = 0; B1 = 1; C1 = 1;
        #10;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_X;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: X=%b, valid=%b",
                         X, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b, valid=%b",
                         expected_X, expected_valid);
                $display("  Got:      X=%b, valid=%b",
                         X, valid);
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

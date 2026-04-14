`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg B11;
    reg B12;
    reg B13;
    reg CY;
    reg [15:0] W0to15;
    wire pre_load;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B11(B11),
        .B12(B12),
        .B13(B13),
        .CY(CY),
        .W0to15(W0to15),
        .pre_load(pre_load)
    );
    task testcase001;

    begin
        test_num = 1;
        B13 = 0; B12 = 0; B11 = 0; CY = 1; W0to15 = 16'h8001;
        $display("Test Case 001: B13=0 (Master Disable)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        B13 = 1; B12 = 0; B11 = 0; CY = 0; W0to15 = 16'h0000;
        $display("Test Case 002: Unconditional Jump (B12=0, B11=0)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        B13 = 1; B12 = 0; B11 = 1; W0to15 = 16'h0001;
        $display("Test Case 003: Zero-flag Jump - Success (W0=1)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        B13 = 1; B12 = 0; B11 = 1; W0to15 = 16'hFFFE;
        $display("Test Case 004: Zero-flag Jump - Fail (W0=0)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        B13 = 1; B12 = 1; B11 = 0; W0to15 = 16'h8000;
        $display("Test Case 005: Non-equal Jump - Success (W15=1)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        B13 = 1; B12 = 1; B11 = 0; W0to15 = 16'h7FFF;
        $display("Test Case 006: Non-equal Jump - Fail (W15=0)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        B13 = 1; B12 = 1; B11 = 1; CY = 1;
        $display("Test Case 007: Carry Jump - Success (CY=1)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        B13 = 1; B12 = 1; B11 = 1; CY = 0;
        $display("Test Case 008: Carry Jump - Fail (CY=0)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        B13 = 1; B12 = 1; B11 = 1; CY = 0; W0to15 = 16'h8001;
        $display("Test Case 009: MUX Isolation (Carry selected, others ignored)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        B13 = 1; B12 = 0; B11 = 1; CY = 1; W0to15 = 16'h8000;
        $display("Test Case 010: MUX Isolation (Zero selected, others ignored)");
        #1;

        check_outputs(1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_pre_load;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pre_load === (expected_pre_load ^ pre_load ^ expected_pre_load)) begin
                $display("PASS");
                $display("  Outputs: pre_load=%b",
                         pre_load);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pre_load=%b",
                         expected_pre_load);
                $display("  Got:      pre_load=%b",
                         pre_load);
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

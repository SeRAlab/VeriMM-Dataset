`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i0;
    reg i1;
    reg i2;
    reg i3;
    wire [3:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .o(o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All inputs LOW");
        i0 = 0; i1 = 0; i2 = 0; i3 = 0;
        #1;

        check_outputs(4'b0000);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: All inputs HIGH");
        i0 = 1; i1 = 1; i2 = 1; i3 = 1;
        #1;

        check_outputs(4'b1111);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: One HIGH, others LOW (i0 different)");
        i0 = 1; i1 = 0; i2 = 0; i3 = 0;
        #1;

        check_outputs(4'b0001);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: One HIGH, others LOW (i3 different)");
        i0 = 0; i1 = 0; i2 = 0; i3 = 1;
        #1;

        check_outputs(4'b0001);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: One LOW, others HIGH (i0 different)");
        i0 = 0; i1 = 1; i2 = 1; i3 = 1;
        #1;

        check_outputs(4'b0001);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: One LOW, others HIGH (i2 different)");
        i0 = 1; i1 = 1; i2 = 0; i3 = 1;
        #1;

        check_outputs(4'b0001);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Otherwise condition (Two HIGH, Two LOW - 1100)");
        i0 = 1; i1 = 1; i2 = 0; i3 = 0;
        #1;

        check_outputs(4'b1010);
    end
    endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Otherwise condition (Two HIGH, Two LOW - 1010)");
        i0 = 1; i1 = 0; i2 = 1; i3 = 0;
        #1;

        check_outputs(4'b1010);
    end
    endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Otherwise condition (Two HIGH, Two LOW - 0110)");
        i0 = 0; i1 = 1; i2 = 1; i3 = 0;
        #1;

        check_outputs(4'b1010);
    end
    endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Check 'X' inputs for 'all same and not 0 or 1' logic");
        i0 = 1'bx; i1 = 1'bx; i2 = 1'bx; i3 = 1'bx;

        #1;


        check_outputs(4'b1110);
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
        input [3:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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

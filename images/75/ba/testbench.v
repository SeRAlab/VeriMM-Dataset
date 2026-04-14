`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] PC;
    wire [15:0] instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC(PC),
        .instruction(instruction)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Accessing PC 0 (First Instruction)");
        PC = 16'h0000;
        #10;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Accessing PC 1 (Second Instruction)");
        PC = 16'h0001;
        #10;

        #1;


        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Accessing PC 5 (Mid-range Instruction)");
        PC = 16'h0005;
        #10;

        #1;


        check_outputs(16'h0005);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Accessing PC 11 (Last Valid Instruction)");
        PC = 16'h000B;
        #10;

        #1;


        check_outputs(16'h000B);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Accessing PC 12 (Out of Range - Boundary)");
        PC = 16'h000C;
        #10;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Accessing PC with high bits set");
        PC = 16'hFFFF;
        #10;


        #1;



        check_outputs(16'h0000);
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
        input [15:0] expected_instruction;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_instruction === (expected_instruction ^ instruction ^ expected_instruction)) begin
                $display("PASS");
                $display("  Outputs: instruction=%h",
                         instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction=%h",
                         expected_instruction);
                $display("  Got:      instruction=%h",
                         instruction);
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

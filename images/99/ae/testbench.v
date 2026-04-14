`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] addr;
    reg [15:0] alu_result;
    reg reg_addr;
    reg stack_command;
    reg [7:0] stack_pointer;
    wire [7:0] true_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .alu_result(alu_result),
        .reg_addr(reg_addr),
        .stack_command(stack_command),
        .stack_pointer(stack_pointer),
        .true_addr(true_addr)
    );
    task testcase001;

        begin
            test_num = 1;
            reg_addr = 0;
            stack_command = 0;
            addr = 8'h55;
            stack_pointer = 8'hAA;
            alu_result = 16'h1234;
            $display("Test Case 001: Default address selection (reg_addr=0, stack_command=0)");
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reg_addr = 1;
            stack_command = 0;
            addr = 8'h00;
            stack_pointer = 8'h00;
            alu_result = 16'hA53C;
            $display("Test Case 002: ALU result selection (reg_addr=1)");
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reg_addr = 0;
            stack_command = 1;
            addr = 8'h11;
            stack_pointer = 8'hF0;
            alu_result = 16'h9999;
            $display("Test Case 003: Stack pointer selection (stack_command=1)");
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reg_addr = 1;
            stack_command = 1;
            addr = 8'h00;
            stack_pointer = 8'hCC;
            alu_result = 16'hBEEF;
            $display("Test Case 004: Priority check - reg_addr should override stack_command");
            #1;

            check_outputs(8'hEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reg_addr = 1;
            stack_command = 0;
            addr = 8'h00;
            stack_pointer = 8'h00;
            alu_result = 16'h00FF;
            $display("Test Case 005: Boundary check - ALU result all ones");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reg_addr = 1;
            stack_command = 0;
            addr = 8'hFF;
            stack_pointer = 8'hFF;
            alu_result = 16'hFF00;
            $display("Test Case 006: Boundary check - ALU lower bits zero, upper bits high");
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_true_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_true_addr === (expected_true_addr ^ true_addr ^ expected_true_addr)) begin
                $display("PASS");
                $display("  Outputs: true_addr=%h",
                         true_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: true_addr=%h",
                         expected_true_addr);
                $display("  Got:      true_addr=%h",
                         true_addr);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data1_i;
    reg [31:0] data2_i;
    reg [2:0] leftright_i;
    reg [31:0] se_i;
    reg [4:0] shamt_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1_i(data1_i),
        .data2_i(data2_i),
        .leftright_i(leftright_i),
        .se_i(se_i),
        .shamt_i(shamt_i),
        .data_o(data_o)
    );
    task testcase001;

        begin
            $display("Test Case 001: Logical Left Shift se_i by 2");
            se_i = 32'h0000_0001;
            leftright_i = 3'b000;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Logical Left Shift se_i by 16");
            se_i = 32'h0000_FFFF;
            leftright_i = 3'b001;
            #1;

            check_outputs(32'hFFFF_0000);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Logical Left Shift data2_i by shamt_i");
            data2_i = 32'h0000_00FF;
            shamt_i = 5'd8;
            leftright_i = 3'b010;
            #1;

            check_outputs(32'h0000_FF00);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Arithmetic Right Shift (SRA) data2_i (Positive) by shamt_i");
            data2_i = 32'h7000_0000;
            shamt_i = 5'd4;
            leftright_i = 3'b011;
            #1;

            check_outputs(32'h0700_0000);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Arithmetic Right Shift (SRA) data2_i (Negative/Sign Ext) by shamt_i");
            data2_i = 32'h8000_0000;
            shamt_i = 5'd4;
            leftright_i = 3'b011;
            #1;

            check_outputs(32'hF800_0000);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Arithmetic Right Shift (SRA) data2_i by data1_i (Variable)");
            data2_i = 32'hC000_0000;
            data1_i = 32'h0000_0002;
            leftright_i = 3'b100;
            #1;

            check_outputs(32'hF000_0000);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Shift se_i by 2 (Boundary Check)");
            se_i = 32'hC000_0000;
            leftright_i = 3'b000;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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

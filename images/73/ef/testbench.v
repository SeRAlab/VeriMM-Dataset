`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] condition;
    reg [31:0] data_0;
    reg [31:0] data_1;
    reg [31:0] data_2;
    reg [31:0] data_3;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .condition(condition),
        .data_0(data_0),
        .data_1(data_1),
        .data_2(data_2),
        .data_3(data_3),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Select data_0 (condition = 00)");
            data_0 = 32'hDEADBEEF;
            data_1 = 32'h00000000;
            data_2 = 32'hFFFFFFFF;
            data_3 = 32'h12345678;
            condition = 2'b00;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Select data_1 (condition = 01)");
            data_0 = 32'hAAAAAAAA;
            data_1 = 32'hBBBBBBBB;
            data_2 = 32'hCCCCCCCC;
            data_3 = 32'hDDDDDDDD;
            condition = 2'b01;
            #1;

            check_outputs(32'hBBBBBBBB);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Select data_2 (condition = 10)");
            data_0 = 32'h11111111;
            data_1 = 32'h22222222;
            data_2 = 32'h33333333;
            data_3 = 32'h44444444;
            condition = 2'b10;
            #1;

            check_outputs(32'h33333333);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Select data_3 (condition = 11)");
            data_0 = 32'h0F0F0F0F;
            data_1 = 32'hF0F0F0F0;
            data_2 = 32'hAAAA5555;
            data_3 = 32'h5555AAAA;
            condition = 2'b11;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: All zeros check");
            data_0 = 32'h0;
            data_1 = 32'h0;
            data_2 = 32'h0;
            data_3 = 32'h0;
            condition = 2'b10;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: High impedance/All ones check");
            data_0 = 32'hFFFFFFFF;
            data_1 = 32'hFFFFFFFF;
            data_2 = 32'hFFFFFFFF;
            data_3 = 32'hFFFFFFFF;
            condition = 2'b00;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Walking bit pattern");
            data_0 = 32'h00000001;
            data_1 = 32'h00000002;
            data_2 = 32'h00000004;
            data_3 = 32'h00000008;
            condition = 2'b11;
            #1;

            check_outputs(32'h00000008);
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
        input [31:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] select;
    wire [1:0] EPC;
    wire [31:0] mfhi;
    wire [31:0] mflo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .select(select),
        .EPC(EPC),
        .mfhi(mfhi),
        .mflo(mflo)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Simple Unsigned Multiplication");
            test_num = test_num + 1;
            select = 2'b00;
            A = 32'd10;
            B = 32'd5;

            #1;


            check_outputs(2'b00, 32'd0, 32'd50);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Multiplication with high-bit overflow");
            test_num = test_num + 1;
            select = 2'b00;
            A = 32'h8000_0000;
            B = 32'd2;

            #1;


            check_outputs(2'b00, 32'h0000_0001, 32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Multiplication by Zero");
            test_num = test_num + 1;
            select = 2'b00;
            A = 32'hFFFF_FFFF;
            B = 32'd0;

            #1;


            check_outputs(2'b00, 32'd0, 32'd0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Simple Unsigned Division");
            test_num = test_num + 1;
            select = 2'b10;
            A = 32'd20;
            B = 32'd3;

            #1;


            check_outputs(2'b00, 32'd2, 32'd6);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Division where A < B");
            test_num = test_num + 1;
            select = 2'b10;
            A = 32'd5;
            B = 32'd10;

            #1;


            check_outputs(2'b00, 32'd5, 32'd0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Division by Zero (EPC Check)");
            test_num = test_num + 1;
            select = 2'b10;
            A = 32'd100;
            B = 32'd0;


            #1;



            check_outputs(2'b01, 32'h0, 32'h0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Maximum Value Multiplication");
            test_num = test_num + 1;
            select = 2'b00;
            A = 32'hFFFF_FFFF;
            B = 32'hFFFF_FFFF;


            #1;



            check_outputs(2'b00, 32'hFFFF_FFFE, 32'h0000_0001);
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
        input [1:0] expected_EPC;
        input [31:0] expected_mfhi;
        input [31:0] expected_mflo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EPC === (expected_EPC ^ EPC ^ expected_EPC) &&
                expected_mfhi === (expected_mfhi ^ mfhi ^ expected_mfhi) &&
                expected_mflo === (expected_mflo ^ mflo ^ expected_mflo)) begin
                $display("PASS");
                $display("  Outputs: EPC=%h, mfhi=%h, mflo=%h",
                         EPC, mfhi, mflo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EPC=%h, mfhi=%h, mflo=%h",
                         expected_EPC, expected_mfhi, expected_mflo);
                $display("  Got:      EPC=%h, mfhi=%h, mflo=%h",
                         EPC, mfhi, mflo);
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

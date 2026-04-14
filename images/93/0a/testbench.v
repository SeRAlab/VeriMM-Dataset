`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] fnc;
    wire equ;
    wire [31:0] res;
    wire slt;
    wire ult;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .fnc(fnc),
        .equ(equ),
        .res(res),
        .slt(slt),
        .ult(ult)
    );
    task testcase001;

        begin
            $display("Testcase 001: Basic Addition");
            test_num = 1;
            a = 32'd100;
            b = 32'd200;
            fnc = 3'b000;

            #1;


            check_outputs(1'b0, 32'd300, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Subtraction");
            test_num = 2;
            a = 32'd500;
            b = 32'd100;
            fnc = 3'b001;

            #1;


            check_outputs(1'b0, 32'd400, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Logical AND");
            test_num = 3;
            a = 32'hFFFF0000;
            b = 32'hAAAA_AAAA;
            fnc = 3'b010;

            #1;


            check_outputs(1'b0, 32'hAAAA0000, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Logical OR");
            test_num = 4;
            a = 32'h0000FFFF;
            b = 32'h5555_5555;
            fnc = 3'b011;

            #1;


            check_outputs(1'b0, 32'h5555FFFF, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Logical XOR");
            test_num = 5;
            a = 32'h12345678;
            b = 32'h12345678;
            fnc = 3'b100;

            #1;


            check_outputs(1'b1, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Signed vs Unsigned Comparison (Neg vs Pos)");
            test_num = 6;
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            fnc = 3'b000;

            #1;


            check_outputs(1'b0, 32'h00000000, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Subtraction resulting in Negative");
            test_num = 7;
            a = 32'd10;
            b = 32'd20;
            fnc = 3'b001;

            #1;


            check_outputs(1'b0, 32'hFFFFFFF6, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Equality Check at Zero");
            test_num = 8;
            a = 32'h00000000;
            b = 32'h00000000;
            fnc = 3'b000;

            #1;


            check_outputs(1'b1, 32'h00000000, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Large Unsigned Comparison");
            test_num = 9;
            a = 32'h7FFFFFFF;
            b = 32'h80000000;
            fnc = 3'b000;

            #1;


            check_outputs(1'b0, 32'hFFFFFFFF, 1'b0, 1'b1);
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
        input expected_equ;
        input [31:0] expected_res;
        input expected_slt;
        input expected_ult;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equ === (expected_equ ^ equ ^ expected_equ) &&
                expected_res === (expected_res ^ res ^ expected_res) &&
                expected_slt === (expected_slt ^ slt ^ expected_slt) &&
                expected_ult === (expected_ult ^ ult ^ expected_ult)) begin
                $display("PASS");
                $display("  Outputs: equ=%b, res=%h, slt=%b, ult=%b",
                         equ, res, slt, ult);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equ=%b, res=%h, slt=%b, ult=%b",
                         expected_equ, expected_res, expected_slt, expected_ult);
                $display("  Got:      equ=%b, res=%h, slt=%b, ult=%b",
                         equ, res, slt, ult);
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

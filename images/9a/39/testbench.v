`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg C_IN;
    reg [3:0] Sel;
    wire C_FLAG;
    wire [7:0] SUM;
    wire Z_FLAG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C_IN(C_IN),
        .Sel(Sel),
        .C_FLAG(C_FLAG),
        .SUM(SUM),
        .Z_FLAG(Z_FLAG)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'd10; B = 8'd20; C_IN = 1'b0; Sel = 4'h0;
            $display("Test Case 001: Addition (10 + 20)");
            #1;

            check_outputs(1'b0, 8'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'h01; C_IN = 1'b0; Sel = 4'h0;
            $display("Test Case 002: Addition with Carry (255 + 1)");
            #1;

            check_outputs(1'b1, 8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'd10; B = 8'd10; C_IN = 1'b1; Sel = 4'h0;
            $display("Test Case 003: Addition with Carry-In (10 + 10 + 1)");
            #1;

            check_outputs(1'b0, 8'd21, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'd50; B = 8'd20; C_IN = 1'b0; Sel = 4'h1;
            $display("Test Case 004: Subtraction (50 - 20)");
            #1;

            check_outputs(1'b0, 8'd30, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'd100; B = 8'd100; C_IN = 1'b0; Sel = 4'h1;
            $display("Test Case 005: Subtraction resulting in Zero (100 - 100)");
            #1;

            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'hAA; B = 8'hF0; C_IN = 1'b0; Sel = 4'h2;
            $display("Test Case 006: Bitwise AND (AA & F0)");
            #1;

            check_outputs(1'b0, 8'hA0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'h0F; B = 8'hF0; C_IN = 1'b0; Sel = 4'h3;
            $display("Test Case 007: Bitwise OR (0F | F0)");
            #1;

            check_outputs(1'b0, 8'hFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'h55; B = 8'h55; C_IN = 1'b0; Sel = 4'h4;
            $display("Test Case 008: Bitwise XOR (55 ^ 55)");
            #1;

            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'h00; B = 8'h00; C_IN = 1'b0; Sel = 4'h5;
            $display("Test Case 009: Bitwise Negation (~00)");
            #1;

            check_outputs(1'b0, 8'hFF, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'b10101010; B = 8'h00; C_IN = 1'b0; Sel = 4'h6;
            $display("Test Case 010: Shift Left (10101010 << 1)");

            #1;


            check_outputs(1'b1, 8'b01010100, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            A = 8'b00000001; B = 8'h00; C_IN = 1'b0; Sel = 4'h7;
            $display("Test Case 011: Shift Right (00000001 >> 1)");
            #1;

            check_outputs(1'b0, 8'h00, 1'b1);
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
        testcase011();
        
        
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
        input expected_C_FLAG;
        input [7:0] expected_SUM;
        input expected_Z_FLAG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_FLAG === (expected_C_FLAG ^ C_FLAG ^ expected_C_FLAG) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM) &&
                expected_Z_FLAG === (expected_Z_FLAG ^ Z_FLAG ^ expected_Z_FLAG)) begin
                $display("PASS");
                $display("  Outputs: C_FLAG=%b, SUM=%h, Z_FLAG=%b",
                         C_FLAG, SUM, Z_FLAG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_FLAG=%b, SUM=%h, Z_FLAG=%b",
                         expected_C_FLAG, expected_SUM, expected_Z_FLAG);
                $display("  Got:      C_FLAG=%b, SUM=%h, Z_FLAG=%b",
                         C_FLAG, SUM, Z_FLAG);
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

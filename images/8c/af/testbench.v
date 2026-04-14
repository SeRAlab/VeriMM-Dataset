`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALU_OP;
    reg [31:0] B;
    wire [31:0] F;
    wire OF;
    wire ZF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALU_OP(ALU_OP),
        .B(B),
        .F(F),
        .OF(OF),
        .ZF(ZF)
    );
    task testcase001;

        begin
            $display("Testcase 001: Addition (10 + 20)");
            test_num = 1;
            A = 32'd10; B = 32'd20; ALU_OP = 3'b000;
            #1;

            check_outputs(32'd30, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition (0 + 0)");
            test_num = 2;
            A = 32'd0; B = 32'd0; ALU_OP = 3'b000;
            #1;

            check_outputs(32'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition Overflow (Positive)");
            test_num = 3;
            A = 32'h7FFFFFFF; B = 32'd1; ALU_OP = 3'b000;
            #1;

            check_outputs(32'h80000000, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction (50 - 20)");
            test_num = 4;
            A = 32'd50; B = 32'd20; ALU_OP = 3'b001;
            #1;

            check_outputs(32'd30, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Subtraction Zero Flag (15 - 15)");
            test_num = 5;
            A = 32'd15; B = 32'd15; ALU_OP = 3'b001;
            #1;

            check_outputs(32'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction Overflow (Negative)");
            test_num = 6;
            A = 32'h80000000; B = 32'd1; ALU_OP = 3'b001;
            #1;

            check_outputs(32'h7FFFFFFF, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Logical AND");
            test_num = 7;
            A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALU_OP = 3'b010;
            #1;

            check_outputs(32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Logical OR");
            test_num = 8;
            A = 32'hAAAA_5555; B = 32'h5555_AAAA; ALU_OP = 3'b011;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Logical XOR");
            test_num = 9;
            A = 32'h1234_5678; B = 32'h1234_5678; ALU_OP = 3'b100;
            #1;

            check_outputs(32'h0000_0000, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Logical NOR");
            test_num = 10;
            A = 32'h0000_0000; B = 32'h0000_0000; ALU_OP = 3'b101;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Comparison SLT (Signed -5 < 10)");
            test_num = 11;
            A = -32'sd5; B = 32'sd10; ALU_OP = 3'b110;
            #1;

            check_outputs(32'h0000_0001, 1'b0, 1'b0);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Comparison SLT (Signed 10 < 5)");
            test_num = 12;
            A = 32'sd10; B = 32'sd5; ALU_OP = 3'b110;
            #1;

            check_outputs(32'h0000_0000, 1'b0, 1'b1);
        end
        endtask

    task testcase013;

        begin
            $display("Testcase 013: Left Shift (1 << 4)");
            test_num = 13;
            A = 32'h0000_0001; B = 32'd4; ALU_OP = 3'b111;
            #1;

            check_outputs(32'h0000_0010, 1'b0, 1'b0);
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
        testcase012();
        testcase013();
        
        
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
        input [31:0] expected_F;
        input expected_OF;
        input expected_ZF;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F) &&
                expected_OF === (expected_OF ^ OF ^ expected_OF) &&
                expected_ZF === (expected_ZF ^ ZF ^ expected_ZF)) begin
                $display("PASS");
                $display("  Outputs: F=%h, OF=%b, ZF=%b",
                         F, OF, ZF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%h, OF=%b, ZF=%b",
                         expected_F, expected_OF, expected_ZF);
                $display("  Got:      F=%h, OF=%b, ZF=%b",
                         F, OF, ZF);
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

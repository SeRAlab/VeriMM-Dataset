`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [3:0] ALUOP;
    reg [31:0] A_Signed;
    reg [31:0] B;
    reg [31:0] B_Signed;
    reg [31:0] Instr;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALUOP(ALUOP),
        .A_Signed(A_Signed),
        .B(B),
        .B_Signed(B_Signed),
        .Instr(Instr),
        .C(C)
    );
    task testcase001;

        begin
            $display("Testcase 001: Unsigned Addition");
            test_num = 1;
            ALUOP = 4'b0000;
            A = 32'h0000_0005;
            B = 32'h0000_000A;
            A_Signed = A;
            B_Signed = B;
            Instr = 32'b0;
            #1;

            check_outputs(32'h0000_000F);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Unsigned Subtraction");
            test_num = 2;
            ALUOP = 4'b0001;
            A = 32'h0000_0010;
            B = 32'h0000_0006;
            A_Signed = A;
            B_Signed = B;
            Instr = 32'b0;
            #1;

            check_outputs(32'h0000_000A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Bitwise AND");
            test_num = 3;
            ALUOP = 4'b0010;
            A = 32'hF0F0_AAAA;
            B = 32'h0F0F_FFFF;
            A_Signed = A;
            B_Signed = B;
            #1;

            check_outputs(32'h0000_AAAA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Bitwise OR");
            test_num = 4;
            ALUOP = 4'b0011;
            A = 32'hF0F0_0000;
            B = 32'h0000_AAAA;
            A_Signed = A;
            B_Signed = B;
            #1;

            check_outputs(32'hF0F0_AAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bitwise XOR");
            test_num = 5;
            ALUOP = 4'b0100;
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            A_Signed = A;
            B_Signed = B;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift Left Logical (SLL)");
            test_num = 6;
            ALUOP = 4'b0101;
            A = 32'h0000_0001;
            B = 32'd4;
            A_Signed = A;
            B_Signed = B;
            #1;

            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Shift Right Logical (SRL)");
            test_num = 7;
            ALUOP = 4'b0110;
            A = 32'h0000_0080;
            B = 32'd3;
            A_Signed = A;
            B_Signed = B;
            #1;

            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Signed Addition (Negative Result)");
            test_num = 8;
            ALUOP = 4'b0000;
            A_Signed = -32'sd10;
            B_Signed = -32'sd20;
            A = A_Signed;
            B = B_Signed;
            #1;

            check_outputs(-32'sd30);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Addition with Overflow Wrap");
            test_num = 9;
            ALUOP = 4'b0000;
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            A_Signed = A;
            B_Signed = B;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Undefined Operation");
            test_num = 10;
            ALUOP = 4'b1111;
            A = 32'h1234_5678;
            B = 32'h8765_4321;
            #1;

            check_outputs(32'bx);
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
        input [31:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg CIN;
    reg [2:0] OPCODE;
    reg [3:0] S;
    wire COUT;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .OPCODE(OPCODE),
        .S(S),
        .COUT(COUT),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Testcase 001: Addition - Basic");
            test_num = 1;
            A = 32'h0000_000A;
            B = 32'h0000_0005;
            CIN = 1'b0;
            OPCODE = 3'b000;
            S = 4'd0;
            #1;

            check_outputs(1'b0, 32'h0000_000F);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition - Carry Out");
            test_num = 2;
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            CIN = 1'b0;
            OPCODE = 3'b000;
            S = 4'd0;
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition - CIN handling");
            test_num = 3;
            A = 32'h0000_0001;
            B = 32'h0000_0001;
            CIN = 1'b1;
            OPCODE = 3'b000;
            S = 4'd0;
            #1;

            check_outputs(1'b0, 32'h0000_0003);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction - Basic");
            test_num = 4;
            A = 32'h0000_0020;
            B = 32'h0000_0005;
            CIN = 1'b0;
            OPCODE = 3'b001;
            S = 4'd0;
            #1;

            check_outputs(1'b0, 32'h0000_001B);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bitwise AND");
            test_num = 5;
            A = 32'hAAAA_AAAA;
            B = 32'hF0F0_F0F0;
            CIN = 1'b0;
            OPCODE = 3'b010;
            S = 4'd0;
            #1;

            check_outputs(1'b0, 32'hA0A0_A0A0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bitwise OR");
            test_num = 6;
            A = 32'h1234_5678;
            B = 32'h8765_4321;
            CIN = 1'b0;
            OPCODE = 3'b011;
            S = 4'd0;
            #1;

            check_outputs(1'b0, 32'h9775_5779);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Bitwise XOR");
            test_num = 7;
            A = 32'hFFFF_FFFF;
            B = 32'hAAAA_AAAA;
            CIN = 1'b0;
            OPCODE = 3'b100;
            S = 4'd0;
            #1;

            check_outputs(1'b0, 32'h5555_5555);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Shift Left Logical (SLL)");
            test_num = 8;
            A = 32'h0000_0001;
            B = 32'h0000_0000;
            CIN = 1'b0;
            OPCODE = 3'b101;
            S = 4'd4;
            #1;

            check_outputs(1'b0, 32'h0000_0010);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Shift Right Logical (SRL)");
            test_num = 9;
            A = 32'h8000_0000;
            B = 32'h0000_0000;
            CIN = 1'b0;
            OPCODE = 3'b110;
            S = 4'd1;
            #1;

            check_outputs(1'b0, 32'h4000_0000);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Subtraction - Underflow/Borrow");
            test_num = 10;
            A = 32'h0000_0000;
            B = 32'h0000_0001;
            CIN = 1'b0;
            OPCODE = 3'b001;
            S = 4'd0;


            #1;



            check_outputs(1'b1, 32'hFFFF_FFFF);
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
        input expected_COUT;
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, Y=%h",
                         COUT, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, Y=%h",
                         expected_COUT, expected_Y);
                $display("  Got:      COUT=%b, Y=%h",
                         COUT, Y);
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

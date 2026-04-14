`timescale 1ns/1ps

module ALU_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] opcode;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_8bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

        begin
            $display("Testcase 001: Addition (5 + 3)");
            A = 8'h05; B = 8'h03; opcode = 3'b000;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition Overflow (255 + 1)");
            A = 8'hFF; B = 8'h01; opcode = 3'b000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Subtraction (10 - 4)");
            A = 8'h0A; B = 8'h04; opcode = 3'b001;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction Underflow (0 - 1)");
            A = 8'h00; B = 8'h01; opcode = 3'b001;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bitwise AND (AA & F0)");
            A = 8'hAA; B = 8'hF0; opcode = 3'b010;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bitwise OR (55 | 0F)");
            A = 8'h55; B = 8'h0F; opcode = 3'b011;
            #1;

            check_outputs(8'h5F);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Bitwise XOR (AA ^ FF)");
            A = 8'hAA; B = 8'hFF; opcode = 3'b100;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Bitwise XOR (C3 ^ C3)");
            A = 8'hC3; B = 8'hC3; opcode = 3'b100;
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
        $display("ALU_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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

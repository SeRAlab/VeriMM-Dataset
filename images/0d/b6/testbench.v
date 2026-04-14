`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] opcode;
    wire [15:0] result;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_16bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .zero_flag(zero_flag)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (10 + 20)", test_num);
            opcode = 4'd0;
            A = 16'h000A;
            B = 16'h0014;
            #1;

            check_outputs(16'h001E, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with Overflow (FFFF + 1)", test_num);
            opcode = 4'd0;
            A = 16'hFFFF;
            B = 16'h0001;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (50 - 20)", test_num);
            opcode = 4'd1;
            A = 16'h0032;
            B = 16'h0014;
            #1;

            check_outputs(16'h001E, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction to Zero (20 - 20)", test_num);
            opcode = 4'd1;
            A = 16'h0014;
            B = 16'h0014;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise AND (F0F0 & AAAA)", test_num);
            opcode = 4'd2;
            A = 16'hF0F0;
            B = 16'hAAAA;
            #1;

            check_outputs(16'hA0A0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise OR (F0F0 | 0F0F)", test_num);
            opcode = 4'd3;
            A = 16'hF0F0;
            B = 16'h0F0F;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise XOR (5555 ^ 5555)", test_num);
            opcode = 4'd4;
            A = 16'h5555;
            B = 16'h5555;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Shift Left (0001 << 4)", test_num);
            opcode = 4'd5;
            A = 16'h0001;
            B = 16'h0004;
            #1;

            check_outputs(16'h0010, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Shift Right (8000 >> 1)", test_num);
            opcode = 4'd6;
            A = 16'h8000;
            B = 16'h0001;
            #1;

            check_outputs(16'h4000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SLT (5 < 10)", test_num);
            opcode = 4'd7;
            A = 16'h0005;
            B = 16'h000A;
            #1;

            check_outputs(16'h0001, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SLT (10 < 5)", test_num);
            opcode = 4'd7;
            A = 16'h000A;
            B = 16'h0005;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_16bit Testbench");
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
        input [15:0] expected_result;
        input expected_zero_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero_flag=%b",
                         result, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero_flag=%b",
                         expected_result, expected_zero_flag);
                $display("  Got:      result=%h, zero_flag=%b",
                         result, zero_flag);
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

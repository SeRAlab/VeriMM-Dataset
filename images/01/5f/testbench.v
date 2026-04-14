`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [2:0] opcode;
    wire [63:0] result;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .zero_flag(zero_flag)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ADD 15 + 30", test_num);
        A = 64'd15; B = 64'd30; opcode = 3'd0;
        #1;

        check_outputs(64'd45, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ADD Overflow to Zero", test_num);
        A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001; opcode = 3'd0;
        #1;

        check_outputs(64'h0000000000000000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUB 100 - 40", test_num);
        A = 64'd100; B = 64'd40; opcode = 3'd1;
        #1;

        check_outputs(64'd60, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUB result zero", test_num);
        A = 64'hABCDE; B = 64'hABCDE; opcode = 3'd1;
        #1;

        check_outputs(64'h0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: AND Bitmask", test_num);
        A = 64'hF0F0F0F0F0F0F0F0; B = 64'h0F0F0F0F0F0F0F0F; opcode = 3'd2;
        #1;

        check_outputs(64'h0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: AND Logic", test_num);
        A = 64'hFFFFFFFFFFFFFFFF; B = 64'h1234567890ABCDEF; opcode = 3'd2;
        #1;

        check_outputs(64'h1234567890ABCDEF, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: OR Logic", test_num);
        A = 64'hAAAAAAAAAAAAAAAA; B = 64'h5555555555555555; opcode = 3'd3;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: OR Zero", test_num);
        A = 64'h0; B = 64'h0; opcode = 3'd3;
        #1;

        check_outputs(64'h0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR self (Zero)", test_num);
        A = 64'hDEADBEEFCAFEBABE; B = 64'hDEADBEEFCAFEBABE; opcode = 3'd4;
        #1;

        check_outputs(64'h0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NOT operand A", test_num);
        A = 64'h0000000000000000; B = 64'hFFFFFFFFFFFFFFFF; opcode = 3'd5;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NOT operand A (Zero Result)", test_num);
        A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0; opcode = 3'd5;
        #1;

        check_outputs(64'h0, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NAND Logic", test_num);
        A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF; opcode = 3'd6;
        #1;

        check_outputs(64'h0, 1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NAND Logic (Inverse of AND)", test_num);
        A = 64'h000000000000000F; B = 64'h0000000000000007; opcode = 3'd6;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFF8, 1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NOR Logic", test_num);
        A = 64'h0; B = 64'h0; opcode = 3'd7;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b0);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NOR Logic (Zero result)", test_num);
        A = 64'hFFFFFFFF00000000; B = 64'h00000000FFFFFFFF; opcode = 3'd7;
        #1;

        check_outputs(64'h0, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        testcase014();
        testcase015();
        
        
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
        input [63:0] expected_result;
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

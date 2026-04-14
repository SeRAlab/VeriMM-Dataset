`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] opcode;
    wire [31:0] result;
    wire zero;

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
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (0 + 0)", test_num);
            opcode = 4'b0000;
            A = 32'h00000000;
            B = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (Positive numbers)", test_num);
            opcode = 4'b0000;
            A = 32'h00001234;
            B = 32'h00004321;
            #1;

            check_outputs(32'h00005555, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (Overflow/Wrap-around)", test_num);
            opcode = 4'b0000;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (A > B)", test_num);
            opcode = 4'b0001;
            A = 32'h00000014;
            B = 32'h00000005;
            #1;

            check_outputs(32'h0000000F, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (A = B)", test_num);
            opcode = 4'b0001;
            A = 32'hABCDEFF0;
            B = 32'hABCDEFF0;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (Result Negative)", test_num);
            opcode = 4'b0001;
            A = 32'h00000000;
            B = 32'h00000001;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise AND", test_num);
            opcode = 4'b0010;
            A = 32'hF0F0AAAA;
            B = 32'h0F0F5555;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise OR", test_num);
            opcode = 4'b0011;
            A = 32'hF0F0AAAA;
            B = 32'h0F0F5555;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise XOR", test_num);
            opcode = 4'b0100;
            A = 32'hAAAAAAAA;
            B = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h55555555, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Shift Left", test_num);
            opcode = 4'b0101;
            A = 32'h00000001;
            B = 32'h00000004;
            #1;

            check_outputs(32'h00000010, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Shift Right", test_num);
            opcode = 4'b0110;
            A = 32'h00000080;
            B = 32'h00000003;
            #1;

            check_outputs(32'h00000010, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SLT (A < B is true)", test_num);
            opcode = 4'b0111;
            A = 32'h00000005;
            B = 32'h0000000A;
            #1;

            check_outputs(32'h00000001, 1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SLT (A < B is false)", test_num);
            opcode = 4'b0111;
            A = 32'h0000000A;
            B = 32'h00000005;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SLT (Signed Negative < Positive)", test_num);
            opcode = 4'b0111;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            #1;

            check_outputs(32'h00000001, 1'b0);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LSL (Shift all bits out)", test_num);
            opcode = 4'b0101;
            A = 32'hFFFFFFFF;
            B = 32'h00000020;
            #1;

            check_outputs(32'h00000000, 1'b1);
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
        input [31:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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

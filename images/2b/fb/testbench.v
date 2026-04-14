`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] opcode;
    wire carry_out;
    wire [15:0] result;
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
        .carry_out(carry_out),
        .result(result),
        .zero_flag(zero_flag)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (no carry)", test_num);
            A = 16'h1234;
            B = 16'h1111;
            opcode = 4'b0000;
            #1;

            check_outputs(1'b0, 16'h2345, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (with carry)", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            opcode = 4'b0000;
            #1;

            check_outputs(1'b1, 16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (positive result)", test_num);
            A = 16'h0005;
            B = 16'h0003;
            opcode = 4'b0001;


            #1;



            check_outputs(1'b0, 16'h0002, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (zero result)", test_num);
            A = 16'hAAAA;
            B = 16'hAAAA;
            opcode = 4'b0001;
            #1;

            check_outputs(1'b0, 16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            A = 16'hF0F0;
            B = 16'hAAAA;
            opcode = 4'b0010;
            #1;

            check_outputs(1'b0, 16'hA0A0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            A = 16'hF0F0;
            B = 16'h0F0F;
            opcode = 4'b0011;
            #1;

            check_outputs(1'b0, 16'hFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR", test_num);
            A = 16'hABCD;
            B = 16'hABCD;
            opcode = 4'b0100;
            #1;

            check_outputs(1'b0, 16'h0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise NOT (Operand A)", test_num);
            A = 16'h0000;
            B = 16'hFFFF;
            opcode = 4'b0101;
            #1;

            check_outputs(1'b0, 16'hFFFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Shift Left", test_num);
            A = 16'h0001;
            B = 16'h0004;
            opcode = 4'b0110;
            #1;

            check_outputs(1'b0, 16'h0010, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Shift Right", test_num);
            A = 16'h8000;
            B = 16'h000F;
            opcode = 4'b0111;
            #1;

            check_outputs(1'b0, 16'h0001, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Shift Right (result zero flag)", test_num);
            A = 16'h0001;
            B = 16'h0001;
            opcode = 4'b0111;
            #1;

            check_outputs(1'b0, 16'h0000, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (with borrow/wrap)", test_num);
            A = 16'h0000;
            B = 16'h0001;
            opcode = 4'b0001;

            #1;


            check_outputs(1'b1, 16'hFFFF, 1'b0);
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
        input expected_carry_out;
        input [15:0] expected_result;
        input expected_zero_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, result=%h, zero_flag=%b",
                         carry_out, result, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, result=%h, zero_flag=%b",
                         expected_carry_out, expected_result, expected_zero_flag);
                $display("  Got:      carry_out=%b, result=%h, zero_flag=%b",
                         carry_out, result, zero_flag);
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

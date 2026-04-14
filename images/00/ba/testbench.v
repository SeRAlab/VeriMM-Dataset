`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] opcode;
    wire carry_out;
    wire [7:0] result;

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
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (No Carry)", test_num);
            A = 8'd15; B = 8'd20; opcode = 3'd0;
            #1;

            check_outputs(1'b0, 8'd35);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (With Carry)", test_num);
            A = 8'hFF; B = 8'h01; opcode = 3'd0;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (No Borrow)", test_num);
            A = 8'd100; B = 8'd40; opcode = 3'd1;
            #1;

            check_outputs(1'b0, 8'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (With Borrow)", test_num);
            A = 8'd10; B = 8'd20; opcode = 3'd1;

            #1;


            check_outputs(1'b1, 8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            A = 8'b1010_1010; B = 8'b1111_0000; opcode = 3'd2;
            #1;

            check_outputs(1'b0, 8'b1010_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            A = 8'b1010_1010; B = 8'b1111_0000; opcode = 3'd3;
            #1;

            check_outputs(1'b0, 8'b1111_1010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR", test_num);
            A = 8'b1010_1010; B = 8'b1111_0000; opcode = 3'd4;
            #1;

            check_outputs(1'b0, 8'b0101_1010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise NOT (A)", test_num);
            A = 8'b1100_0011; B = 8'b0000_0000; opcode = 3'd5;
            #1;

            check_outputs(1'b0, 8'b0011_1100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Shift Left", test_num);
            A = 8'b0000_0111; B = 8'd2; opcode = 3'd6;

            #1;


            check_outputs(1'b0, 8'b0001_1100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Shift Right", test_num);
            A = 8'b1110_0000; B = 8'd3; opcode = 3'd7;
            #1;

            check_outputs(1'b0, 8'b0001_1100);
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, result=%h",
                         carry_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, result=%h",
                         expected_carry_out, expected_result);
                $display("  Got:      carry_out=%b, result=%h",
                         carry_out, result);
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

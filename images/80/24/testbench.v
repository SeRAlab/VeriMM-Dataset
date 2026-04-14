`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] opcode;
    wire [3:0] out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .out(out),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (3 + 2)", test_num);
            A = 4'd3; B = 4'd2; opcode = 3'b000;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (12 + 4)", test_num);
            A = 4'd12; B = 4'd4; opcode = 3'b000;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (10 - 4)", test_num);
            A = 4'd10; B = 4'd4; opcode = 3'b001;
            #1;

            check_outputs(4'd6, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (7 - 7)", test_num);
            A = 4'd7; B = 4'd7; opcode = 3'b001;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND (1010 & 1100)", test_num);
            A = 4'b1010; B = 4'b1100; opcode = 3'b010;
            #1;

            check_outputs(4'b1000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND (1010 & 0101)", test_num);
            A = 4'b1010; B = 4'b0101; opcode = 3'b010;
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR (1000 | 0001)", test_num);
            A = 4'b1000; B = 4'b0001; opcode = 3'b011;
            #1;

            check_outputs(4'b1001, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR (0000 | 0000)", test_num);
            A = 4'b0000; B = 4'b0000; opcode = 3'b011;
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise XOR (1010 ^ 1111)", test_num);
            A = 4'b1010; B = 4'b1111; opcode = 3'b100;
            #1;

            check_outputs(4'b0101, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise XOR (1101 ^ 1101)", test_num);
            A = 4'b1101; B = 4'b1101; opcode = 3'b100;
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left Shift (0001 << 2)", test_num);
            A = 4'b0001; B = 4'd2; opcode = 3'b101;
            #1;

            check_outputs(4'b0100, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left Shift (1000 << 1)", test_num);
            A = 4'b1000; B = 4'd1; opcode = 3'b101;
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right Shift (1000 >> 2)", test_num);
            A = 4'b1000; B = 4'd2; opcode = 3'b110;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right Shift (0001 >> 1)", test_num);
            A = 4'b0001; B = 4'd1; opcode = 3'b110;
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise NOT (~1010)", test_num);
            A = 4'b1010; B = 4'b0000; opcode = 3'b111;
            #1;

            check_outputs(4'b0101, 1'b0);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise NOT (~1111)", test_num);
            A = 4'b1111; B = 4'b0000; opcode = 3'b111;
            #1;

            check_outputs(4'b0000, 1'b1);
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
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [3:0] expected_out;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: out=%h, zero=%b",
                         out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, zero=%b",
                         expected_out, expected_zero);
                $display("  Got:      out=%h, zero=%b",
                         out, zero);
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

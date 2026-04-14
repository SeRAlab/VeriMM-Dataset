`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [1:0] opcode;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'd3; b = 4'd4; opcode = 2'b00;
            $display("Test %0d: Addition (3 + 4)", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'd12; b = 4'd7; opcode = 2'b00;
            $display("Test %0d: Addition Overflow (12 + 7 = 19 -> 3)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'd10; b = 4'd3; opcode = 2'b01;
            $display("Test %0d: Subtraction (10 - 3)", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'd2; b = 4'd5; opcode = 2'b01;
            $display("Test %0d: Subtraction Wrap-around (2 - 5 = -3 -> 13)", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'b1010; b = 4'b1100; opcode = 2'b10;
            $display("Test %0d: Bitwise AND (1010 & 1100)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'b1111; b = 4'b0000; opcode = 2'b10;
            $display("Test %0d: Bitwise AND (All zero result)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 4'b1010; b = 4'b0101; opcode = 2'b11;
            $display("Test %0d: Bitwise OR (1010 | 0101)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 4'b0011; b = 4'b0110; opcode = 2'b11;
            $display("Test %0d: Bitwise OR (0011 | 0110)", test_num);
            #1;

            check_outputs(4'b0111);
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
        input [3:0] expected_result;
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

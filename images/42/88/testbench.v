`timescale 1ns/1ps

module simple_alu_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] opcode;
    wire [7:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_alu dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition (8'h0A + 8'h14)", test_num);
            a = 8'h0A; b = 8'h14; opcode = 3'b000;
            #1;

            check_outputs(8'h1E, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition with Wrap-around (8'hFF + 8'h01)", test_num);
            a = 8'hFF; b = 8'h01; opcode = 3'b000;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Subtraction (8'h20 - 8'h05)", test_num);
            a = 8'h20; b = 8'h05; opcode = 3'b001;
            #1;

            check_outputs(8'h1B, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction (8'hAA - 8'hAA)", test_num);
            a = 8'hAA; b = 8'hAA; opcode = 3'b001;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Bitwise AND (8'hF0 & 8'h0F)", test_num);
            a = 8'hF0; b = 8'h0F; opcode = 3'b010;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bitwise OR (8'hCC | 8'h33)", test_num);
            a = 8'hCC; b = 8'h33; opcode = 3'b011;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bitwise XOR (8'hAA ^ 8'h55)", test_num);
            a = 8'hAA; b = 8'h55; opcode = 3'b100;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Bitwise NOT (~8'hAA, B=8'hFF ignored)", test_num);
            a = 8'hAA; b = 8'hFF; opcode = 3'b101;
            #1;

            check_outputs(8'h55, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Bitwise NOT (~8'hFF)", test_num);
            a = 8'hFF; b = 8'h00; opcode = 3'b101;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Subtraction Underflow (8'h00 - 8'h01)", test_num);
            a = 8'h00; b = 8'h01; opcode = 3'b001;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_alu Testbench");
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
        input [7:0] expected_result;
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

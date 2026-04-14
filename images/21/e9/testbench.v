`timescale 1ns/1ps

module alu_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] op;
    wire [7:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_8bit dut (
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (5 + 3)", test_num);
            A = 8'h05;
            B = 8'h03;
            op = 3'b000;
            #1;

            check_outputs(8'h08, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with wrap-around (255 + 1)", test_num);
            A = 8'hFF;
            B = 8'h01;
            op = 3'b000;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            A = 8'h0A;
            B = 8'h04;
            op = 3'b001;
            #1;

            check_outputs(8'h06, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction resulting in zero (5 - 5)", test_num);
            A = 8'h05;
            B = 8'h05;
            op = 3'b001;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with negative result (2 - 5)", test_num);
            A = 8'h02;
            B = 8'h05;
            op = 3'b001;
            #1;

            check_outputs(8'hFD, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (AA & 55)", test_num);
            A = 8'hAA;
            B = 8'h55;
            op = 3'b010;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (FF & 0F)", test_num);
            A = 8'hFF;
            B = 8'h0F;
            op = 3'b010;
            #1;

            check_outputs(8'h0F, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR (F0 | 0F)", test_num);
            A = 8'hF0;
            B = 8'h0F;
            op = 3'b011;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR with zeros (0 | 0)", test_num);
            A = 8'h00;
            B = 8'h00;
            op = 3'b011;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR (AA ^ FF)", test_num);
            A = 8'hAA;
            B = 8'hFF;
            op = 3'b100;
            #1;

            check_outputs(8'h55, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR same values (55 ^ 55)", test_num);
            A = 8'h55;
            B = 8'h55;
            op = 3'b100;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_8bit Testbench");
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

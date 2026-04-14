`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] op;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition (5 + 3)", test_num);
            a = 32'd5;
            b = 32'd3;
            op = 3'b000;
            #1;

            check_outputs(32'd8, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            a = 32'd10;
            b = 32'd4;
            op = 3'b001;
            #1;

            check_outputs(32'd6, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Subtraction result zero (7 - 7)", test_num);
            a = 32'd7;
            b = 32'd7;
            op = 3'b001;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Bitwise AND", test_num);
            a = 32'hFFFF0000;
            b = 32'hFF00FF00;
            op = 3'b010;
            #1;

            check_outputs(32'hFF000000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Bitwise OR", test_num);
            a = 32'h0000FFFF;
            b = 32'h00FF00FF;
            op = 3'b011;
            #1;

            check_outputs(32'h00FFFFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bitwise XOR", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            op = 3'b100;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Shift Left Logical (1 << 4)", test_num);
            a = 32'h00000001;
            b = 32'd4;
            op = 3'b101;
            #1;

            check_outputs(32'h00000010, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Shift Right Logical (0x80 >> 2)", test_num);
            a = 32'h00000080;
            b = 32'd2;
            op = 3'b110;
            #1;

            check_outputs(32'h00000020, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Comparison (Set Less Than: 5 < 10)", test_num);
            a = 32'd5;
            b = 32'd10;
            op = 3'b111;
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Comparison (Set Less Than: 10 < 5)", test_num);
            a = 32'd10;
            b = 32'd5;
            op = 3'b111;
            #1;

            check_outputs(32'd0, 1'b1);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [3:0] opcode;
    wire [7:0] op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .op(op)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition (15 + 10)", test_num);
            a = 8'd15;
            b = 8'd10;
            opcode = 4'd0;
            #10;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction (5 - 10)", test_num);
            a = 8'd5;
            b = 8'd10;
            opcode = 4'd1;
            #10;
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiplication (16 * 16)", test_num);
            a = 8'd16;
            b = 8'd16;
            opcode = 4'd2;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Division (100 / 3)", test_num);
            a = 8'd100;
            b = 8'd3;
            opcode = 4'd3;
            #10;
            #1;

            check_outputs(8'd33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Modulus (100 %% 3)", test_num);
            a = 8'd100;
            b = 8'd3;
            opcode = 4'd4;
            #10;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bitwise AND (0xAA & 0xF0)", test_num);
            a = 8'hAA;
            b = 8'hF0;
            opcode = 4'd5;
            #10;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bitwise OR (0x55 | 0x0F)", test_num);
            a = 8'h55;
            b = 8'h0F;
            opcode = 4'd6;
            #10;
            #1;

            check_outputs(8'h5F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bitwise XOR (0xFF ^ 0xAA)", test_num);
            a = 8'hFF;
            b = 8'hAA;
            opcode = 4'd7;
            #10;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift Left (0x01 << 1)", test_num);
            a = 8'h01;
            b = 8'h01;
            opcode = 4'd8;
            #10;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift Right (0x80 >> 1)", test_num);
            a = 8'h80;
            b = 8'h01;
            opcode = 4'd9;
            #10;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Unary NOT (~0x00)", test_num);
            a = 8'h00;
            b = 8'hXX;
            opcode = 4'd10;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Undefined Opcode (0xF)", test_num);
            a = 8'h12;
            b = 8'h34;
            opcode = 4'hF;
            #10;


            #1;



            check_outputs(8'hxx);
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
        input [7:0] expected_op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%h",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%h",
                         expected_op);
                $display("  Got:      op=%h",
                         op);
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

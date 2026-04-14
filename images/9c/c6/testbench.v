`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input1;
    reg [7:0] input2;
    reg [2:0] opcode;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            input1 = 8'd15;
            input2 = 8'd10;
            opcode = 3'b000;
            $display("Test %0d: Addition (15 + 10)", test_num);
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input1 = 8'd100;
            input2 = 8'd30;
            opcode = 3'b001;
            $display("Test %0d: Subtraction (100 - 30)", test_num);
            #1;

            check_outputs(8'd70);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input1 = 8'd10;
            input2 = 8'd20;
            opcode = 3'b001;
            $display("Test %0d: Subtraction (10 - 20)", test_num);
            #1;

            check_outputs(8'd246);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input1 = 8'd12;
            input2 = 8'd5;
            opcode = 3'b010;
            $display("Test %0d: Multiplication (12 * 5)", test_num);
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            input1 = 8'd64;
            input2 = 8'd8;
            opcode = 3'b010;
            $display("Test %0d: Multiplication (64 * 8)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            input1 = 8'd80;
            input2 = 8'd5;
            opcode = 3'b011;
            $display("Test %0d: Division (80 / 5)", test_num);
            #1;

            check_outputs(8'd16);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            input1 = 8'hF0;
            input2 = 8'hCC;
            opcode = 3'b100;
            $display("Test %0d: Bitwise AND (hF0 & hCC)", test_num);
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            input1 = 8'hF0;
            input2 = 8'h0F;
            opcode = 3'b101;
            $display("Test %0d: Bitwise OR (hF0 | h0F)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            input1 = 8'hAA;
            input2 = 8'h55;
            opcode = 3'b110;
            $display("Test %0d: Bitwise XOR (hAA ^ h55)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            input1 = 8'h0F;
            input2 = 8'h00;
            opcode = 3'b111;
            $display("Test %0d: Bitwise NOT (~h0F)", test_num);
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            input1 = 8'd255;
            input2 = 8'd255;
            opcode = 3'b000;
            $display("Test %0d: Addition Overflow (255 + 255)", test_num);
            #1;

            check_outputs(8'd254);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] operand_a;
    reg round;
    reg [7:0] shift;
    wire carry;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .operand_a(operand_a),
        .round(round),
        .shift(shift),
        .carry(carry),
        .result(result)
    );
    task testcase001;

    begin
        $display("Testcase 001: No shift");
        test_num = 1;
        operand_a = 8'hA5;
        shift = 8'd0;
        round = 0;
        #1;

        check_outputs(1'b0, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Left shift 1 (No Overflow)");
        test_num = 2;
        operand_a = 8'h55;
        shift = 8'd1;
        round = 0;
        #1;

        check_outputs(1'b0, 8'hAA);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Left shift 1 (MSB Overflow)");
        test_num = 3;
        operand_a = 8'h81;
        shift = 8'd1;
        round = 0;
        #1;

        check_outputs(1'b1, 8'h02);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Left shift 4");
        test_num = 4;
        operand_a = 8'hF0;
        shift = 8'd4;
        round = 0;

        #1;


        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Right shift 1 (No rounding)");
        test_num = 5;
        operand_a = 8'hA5;
        shift = 8'hFF;
        round = 0;
        #1;

        check_outputs(1'b1, 8'h52);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Right shift 1 (Rounding active, LSB was 1)");
        test_num = 6;
        operand_a = 8'hA5;
        shift = 8'hFF;
        round = 1;

        #1;


        check_outputs(1'b1, 8'h53);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Right shift 1 (Rounding active, LSB was 0)");
        test_num = 7;
        operand_a = 8'hA4;
        shift = 8'hFF;
        round = 1;
        #1;

        check_outputs(1'b0, 8'h52);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Right shift 3 (Rounding active)");
        test_num = 8;
        operand_a = 8'hA7;
        shift = 8'hFD;
        round = 1;



        #1;




        check_outputs(1'b1, 8'h15);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Max Left Shift (7)");
        test_num = 9;
        operand_a = 8'h01;
        shift = 8'd7;
        round = 0;
        #1;

        check_outputs(1'b0, 8'h80);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Boundary Check - Right Shift 7");
        test_num = 10;
        operand_a = 8'hFF;
        shift = 8'hF9;
        round = 1;



        #1;




        check_outputs(1'b1, 8'h02);
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
        input expected_carry;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, result=%h",
                         carry, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, result=%h",
                         expected_carry, expected_result);
                $display("  Got:      carry=%b, result=%h",
                         carry, result);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg [4:0] shift_amount;
    reg [1:0] shift_direction;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .shift_direction(shift_direction),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 32'h00000001;
            shift_amount = 5'd4;
            shift_direction = 2'b00;
            $display("Test %0d: LSL basic (1 << 4)", test_num);
            #1;

            check_outputs(32'h00000010, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 32'h00000010;
            shift_amount = 5'd4;
            shift_direction = 2'b01;
            $display("Test %0d: LSR basic (16 >> 4)", test_num);
            #1;

            check_outputs(32'h00000001, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 32'h40000000;
            shift_amount = 5'd2;
            shift_direction = 2'b10;
            $display("Test %0d: ASR positive", test_num);
            #1;

            check_outputs(32'h10000000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 32'h80000000;
            shift_amount = 5'd2;
            shift_direction = 2'b10;
            $display("Test %0d: ASR negative (sign extension)", test_num);
            #1;

            check_outputs(32'hE0000000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 32'h80000000;
            shift_amount = 5'd1;
            shift_direction = 2'b00;
            $display("Test %0d: LSL resulting in zero", test_num);
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 32'h00000001;
            shift_amount = 5'd1;
            shift_direction = 2'b01;
            $display("Test %0d: LSR resulting in zero", test_num);
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 32'hABCDE123;
            shift_amount = 5'd0;
            shift_direction = 2'b00;
            $display("Test %0d: Shift by zero", test_num);
            #1;

            check_outputs(32'hABCDE123, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 32'hFFFFFFFF;
            shift_amount = 5'd31;
            shift_direction = 2'b01;
            $display("Test %0d: LSR shift by 31", test_num);
            #1;

            check_outputs(32'h00000001, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data_in = 32'h80000000;
            shift_amount = 5'd31;
            shift_direction = 2'b10;
            $display("Test %0d: ASR shift by 31 (all ones)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data_in = 32'h00000000;
            shift_amount = 5'd15;
            shift_direction = 2'b00;
            $display("Test %0d: Zero input", test_num);
            #1;

            check_outputs(32'h00000000, 1'b1);
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

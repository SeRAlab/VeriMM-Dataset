`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg [3:0] operand1;
    reg [3:0] operand2;
    reg [1:0] operator;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .operand1(operand1),
        .operand2(operand2),
        .operator(operator),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

        begin
            clear = 1;
            #10;
            clear = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            operand1 = 4'd5;
            operand2 = 4'd3;
            operator = 2'b00;
            #10;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            operand1 = 4'd10;
            operand2 = 4'd7;
            operator = 2'b00;
            #10;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            operand1 = 4'd12;
            operand2 = 4'd4;
            operator = 2'b01;
            #10;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            operand1 = 4'd3;
            operand2 = 4'd5;
            operator = 2'b01;
            #10;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            operand1 = 4'd2;
            operand2 = 4'd4;
            operator = 2'b10;
            #10;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            operand1 = 4'd5;
            operand2 = 4'd4;
            operator = 2'b10;
            #10;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            operand1 = 4'd15;
            operand2 = 4'd3;
            operator = 2'b11;
            #10;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            operand1 = 4'd9;
            operand2 = 4'd2;
            operator = 2'b11;
            #10;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            operand1 = 4'd7;
            operand2 = 4'd7;
            operator = 2'b00;
            clear = 1;
            #10;
            #1;

            check_outputs(4'd0);
            clear = 0;
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            operand1 = 4'd15;
            operand2 = 4'd1;
            operator = 2'b00;
            #10;
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_result;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clear, operand1, operand2, operator, result);
    end

endmodule

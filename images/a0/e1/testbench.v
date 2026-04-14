`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] num1;
    reg [7:0] num2;
    reg [1:0] opcode;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .num1(num1),
        .num2(num2),
        .opcode(opcode),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            num1 = 8'd0;
            num2 = 8'd0;
            opcode = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Addition (10 + 20)", test_num);
            num1 = 8'sd10;
            num2 = 8'sd20;
            opcode = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Addition (-15 + -5)", test_num);
            num1 = -8'sd15;
            num2 = -8'sd5;
            opcode = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-8'sd20);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (50 - 20)", test_num);
            num1 = 8'sd50;
            num2 = 8'sd20;
            opcode = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd30);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (-10 - -30)", test_num);
            num1 = -8'sd10;
            num2 = -8'sd30;
            opcode = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd20);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (4 * -3)", test_num);
            num1 = 8'sd4;
            num2 = -8'sd3;
            opcode = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-8'sd12);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (-5 * -4)", test_num);
            num1 = -8'sd5;
            num2 = -8'sd4;
            opcode = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd20);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Division (100 / 5)", test_num);
            num1 = 8'sd100;
            num2 = 8'sd5;
            opcode = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'sd20);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Division (-21 / 3)", test_num);
            num1 = -8'sd21;
            num2 = 8'sd3;
            opcode = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-8'sd7);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (100 + 50)", test_num);
            num1 = 8'sd100;
            num2 = 8'sd50;
            opcode = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'sd150);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Truncation (20 * 10)", test_num);
            num1 = 8'sd20;
            num2 = 8'sd10;
            opcode = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'sd200);
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
        input [7:0] expected_result;
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
        $dumpvars(0,clk, num1, num2, opcode, result);
    end

endmodule

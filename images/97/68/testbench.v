`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] num1;
    reg [7:0] num2;
    reg [1:0] op;
    reg reset;
    wire overflow;
    wire [7:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .num1(num1),
        .num2(num2),
        .op(op),
        .reset(reset),
        .overflow(overflow),
        .result(result),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            num1 = 0;
            num2 = 0;
            op = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            num1 = 8'd50;
            num2 = 8'd30;
            op = OP_ADD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd80, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            num1 = 8'd200;
            num2 = 8'd100;
            op = OP_ADD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h2C, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            num1 = 8'd100;
            num2 = 8'd40;
            op = OP_SUB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd60, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            num1 = 8'd75;
            num2 = 8'd75;
            op = OP_SUB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd20;
            op = OP_SUB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd246, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            num1 = 8'd12;
            num2 = 8'd10;
            op = OP_MUL;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd120, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            num1 = 8'd50;
            num2 = 8'd10;
            op = OP_MUL;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'hF4, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            num1 = 8'd200;
            num2 = 8'd4;
            op = OP_DIV;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd50, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            num1 = 8'd100;
            num2 = 8'd0;
            op = OP_DIV;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00, 1'b1);
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
        input expected_overflow;
        input [7:0] expected_result;
        input expected_zero;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h, zero=%b",
                         overflow, result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h, zero=%b",
                         expected_overflow, expected_result, expected_zero);
                $display("  Got:      overflow=%b, result=%h, zero=%b",
                         overflow, result, zero);
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
        $dumpvars(0,clk, num1, num2, op, reset, overflow, result, zero);
    end

endmodule

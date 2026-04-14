`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] opcode;
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg rst;
    wire ovf;
    wire [7:0] result;
    wire unf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .opcode(opcode),
        .operand1(operand1),
        .operand2(operand2),
        .rst(rst),
        .ovf(ovf),
        .result(result),
        .unf(unf)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            opcode = 0;
            operand1 = 0;
            operand2 = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (No Overflow)", test_num);
            reset_dut();
            @(posedge clk);
            opcode = 2'b00; operand1 = 8'd10; operand2 = 8'd20;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd30, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (With Overflow)", test_num);
            reset_dut();
            @(posedge clk);
            opcode = 2'b00; operand1 = 8'd200; operand2 = 8'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd44, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction", test_num);
            reset_dut();
            @(posedge clk);
            opcode = 2'b01; operand1 = 8'd50; operand2 = 8'd20;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd30, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (No Overflow)", test_num);
            reset_dut();
            @(posedge clk);
            opcode = 2'b10; operand1 = 8'd12; operand2 = 8'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd60, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (With Overflow)", test_num);
            reset_dut();
            @(posedge clk);
            opcode = 2'b10; operand1 = 8'd40; operand2 = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd144, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division", test_num);
            reset_dut();
            @(posedge clk);
            opcode = 2'b11; operand1 = 8'd100; operand2 = 8'd4;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd25, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (Small / Large)", test_num);
            reset_dut();
            @(posedge clk);
            opcode = 2'b11; operand1 = 8'd5; operand2 = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 1'b0);
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
        input expected_ovf;
        input [7:0] expected_result;
        input expected_unf;
        begin
            if (expected_ovf === (expected_ovf ^ ovf ^ expected_ovf) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_unf === (expected_unf ^ unf ^ expected_unf)) begin
                $display("PASS");
                $display("  Outputs: ovf=%b, result=%h, unf=%b",
                         ovf, result, unf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ovf=%b, result=%h, unf=%b",
                         expected_ovf, expected_result, expected_unf);
                $display("  Got:      ovf=%b, result=%h, unf=%b",
                         ovf, result, unf);
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
        $dumpvars(0,clk, opcode, operand1, operand2, rst, ovf, result, unf);
    end

endmodule

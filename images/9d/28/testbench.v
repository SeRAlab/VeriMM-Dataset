`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] opcode;
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg rst;
    wire [7:0] result;
    wire valid;

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
        .result(result),
        .valid(valid)
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            opcode = 2'b00; operand1 = 8'd15; operand2 = 8'd10;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd25, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            opcode = 2'b00; operand1 = -8'd5; operand2 = -8'd10;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(-8'd15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            opcode = 2'b01; operand1 = 8'd50; operand2 = 8'd20;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            opcode = 2'b01; operand1 = 8'd10; operand2 = 8'd20;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(-8'd10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            opcode = 2'b10; operand1 = 8'd4; operand2 = 8'd12;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd48, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            opcode = 2'b10; operand1 = -8'd3; operand2 = 8'd5;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(-8'd15, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            opcode = 2'b11; operand1 = 8'd100; operand2 = 8'd4;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd25, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            opcode = 2'b11; operand1 = -8'd40; operand2 = 8'd8;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(-8'd5, 1'b1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            opcode = 2'b10; operand1 = 8'd0; operand2 = -8'd5;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            rst = 1;
            #1;

            if (valid === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: Reset state valid=0");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Reset state valid=1");
            end
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
        input expected_valid;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
        $dumpvars(0,clk, opcode, operand1, operand2, rst, result, valid);
    end

endmodule

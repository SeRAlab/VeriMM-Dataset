`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] opcode;
    reg [15:0] operand1;
    reg [15:0] operand2;
    reg rst;
    wire [15:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
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
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task drive_instruction;

        input [3:0] op;
        input [15:0] a;
        input [15:0] b;
        begin
            @(posedge clk);
            #1;
            opcode = op;
            operand1 = a;
            operand2 = b;
            @(posedge clk);
            #1;
            opcode = 0;
            operand1 = 0;
            operand2 = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (10 + 20)", test_num);
            reset_dut();
            drive_instruction(OP_ADD, 16'd10, 16'd20);

            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (100 - 45)", test_num);
            reset_dut();
            drive_instruction(OP_SUB, 16'd100, 16'd45);
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (12 * 12)", test_num);
            reset_dut();
            drive_instruction(OP_MUL, 16'd12, 16'd12);
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd144, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division (500 / 10)", test_num);
            reset_dut();
            drive_instruction(OP_DIV, 16'd500, 16'd10);
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd50, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction resulting in zero", test_num);
            reset_dut();
            drive_instruction(OP_SUB, 16'd77, 16'd77);
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_result;
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

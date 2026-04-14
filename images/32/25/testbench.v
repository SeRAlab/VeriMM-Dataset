`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] opcode;
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg rst;
    wire [7:0] result;

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
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            opcode_in = 4'b0000;
            operand1 = 8'h00;
            operand2 = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            $display("System Reset Complete.");
        end
        endtask
    task run_instruction;

        input [3:0] op;
        input [7:0] a;
        input [7:0] b;
        begin
            @(posedge clk);
            opcode_in = op;
            operand1 = a;
            operand2 = b;


            repeat(5) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Simple Addition (10 + 20)", test_num);
            reset_dut();
            run_instruction(OP_ADD, 8'd10, 8'd20);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Simple Subtraction (50 - 15)", test_num);
            reset_dut();
            run_instruction(OP_SUB, 8'd50, 8'd15);
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Addition with Zero (0 + 128)", test_num);
            reset_dut();
            run_instruction(OP_ADD, 8'd0, 8'd128);
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Subtraction Resulting in Zero (42 - 42)", test_num);
            reset_dut();
            run_instruction(OP_SUB, 8'd42, 8'd42);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Addition Overflow (250 + 10)", test_num);
            reset_dut();
            run_instruction(OP_ADD, 8'd250, 8'd10);
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Subtraction Underflow (5 - 10)", test_num);
            reset_dut();
            run_instruction(OP_SUB, 8'd5, 8'd10);
            #1;

            check_outputs(8'hFB);
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
        testcase006();
        
        
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
        $dumpvars(0,clk, opcode, operand1, operand2, rst, result);
    end

endmodule

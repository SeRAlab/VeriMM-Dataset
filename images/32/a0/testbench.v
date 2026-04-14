`timescale 1ns/1ps

module pipelined_alu_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] opcode;
    reg [15:0] operand_a;
    reg [15:0] operand_b;
    reg rst;
    wire [15:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_alu dut (
        .clk(clk),
        .opcode(opcode),
        .operand_a(operand_a),
        .operand_b(operand_b),
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
        operand_a = 0;
        operand_b = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Simple Addition (15 + 25)");
        reset_dut();
        test_num = test_num + 1;


        opcode = 2'b00; operand_a = 16'd15; operand_b = 16'd25;
        @(posedge clk);


        opcode = 0; operand_a = 0; operand_b = 0;


        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'd40, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Simple Subtraction (100 - 40)");
        reset_dut();
        test_num = test_num + 1;

        opcode = 2'b01; operand_a = 16'd100; operand_b = 16'd40;
        @(posedge clk);

        opcode = 0; operand_a = 0; operand_b = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'd60, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Bitwise AND (0xAAAA & 0x1234)");
        reset_dut();
        test_num = test_num + 1;

        opcode = 2'b10; operand_a = 16'hAAAA; operand_b = 16'h1234;
        @(posedge clk);

        opcode = 0; operand_a = 0; operand_b = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0220, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Pipeline Throughput (Checking 5th operation)");
        reset_dut();
        test_num = test_num + 1;


        opcode = 2'b00; operand_a = 16'd1; operand_b = 16'd1; @(posedge clk);

        opcode = 2'b00; operand_a = 16'd2; operand_b = 16'd2; @(posedge clk);

        opcode = 2'b00; operand_a = 16'd3; operand_b = 16'd3; @(posedge clk);

        opcode = 2'b00; operand_a = 16'd4; operand_b = 16'd4; @(posedge clk);

        opcode = 2'b00; operand_a = 16'd10; operand_b = 16'd20; @(posedge clk);



        opcode = 0; operand_a = 0; operand_b = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'd30, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Max value addition (0xFFFF + 1)");
        reset_dut();
        test_num = test_num + 1;

        opcode = 2'b00; operand_a = 16'hFFFF; operand_b = 16'h0001;
        @(posedge clk);

        opcode = 0; operand_a = 0; operand_b = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Subtraction Underflow (5 - 10)");
        reset_dut();
        test_num = test_num + 1;

        opcode = 2'b01; operand_a = 16'h0005; operand_b = 16'h000A;
        @(posedge clk);

        opcode = 0; operand_a = 0; operand_b = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFb, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_alu Testbench");
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
        $dumpvars(0,clk, opcode, operand_a, operand_b, rst, result, valid);
    end

endmodule

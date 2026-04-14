`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction;
    reg rst;
    wire [5:0] opcode;
    wire [31:0] operand1;
    wire [31:0] operand2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .instruction(instruction),
        .rst(rst),
        .opcode(opcode),
        .operand1(operand1),
        .operand2(operand2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        $display("Resetting DUT...");
        rst = 1;
        instruction = 32'h0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Instruction decoding", test_num);
        reset_dut();



        instruction = 32'h843543CD;

        @(posedge clk);
        instruction = 32'h0;
        @(posedge clk);

        #1;
        #1;

        check_outputs(6'h21, 32'h000006AA, 32'h000003CD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All ones in instruction fields", test_num);
        reset_dut();


        instruction = 32'hFFFFFFFF;

        @(posedge clk);
        instruction = 32'h0;
        @(posedge clk);

        #1;
        #1;

        check_outputs(6'h3F, 32'h00001FFF, 32'h00001FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All zeros instruction", test_num);
        reset_dut();

        instruction = 32'h00000000;

        @(posedge clk);
        @(posedge clk);

        #1;
        #1;

        check_outputs(6'h00, 32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating bit pattern (0xAAAAAAAA)", test_num);
        reset_dut();


        instruction = 32'hAAAAAAAA;

        @(posedge clk);
        @(posedge clk);

        #1;
        #1;

        check_outputs(6'h2A, 32'h00001555, 32'h00000AAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating bit pattern (0x55555555)", test_num);
        reset_dut();


        instruction = 32'h55555555;

        @(posedge clk);
        @(posedge clk);

        #1;
        #1;

        check_outputs(6'h15, 32'h00000AAA, 32'h00001555);
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
        input [5:0] expected_opcode;
        input [31:0] expected_operand1;
        input [31:0] expected_operand2;
        begin
            if (expected_opcode === (expected_opcode ^ opcode ^ expected_opcode) &&
                expected_operand1 === (expected_operand1 ^ operand1 ^ expected_operand1) &&
                expected_operand2 === (expected_operand2 ^ operand2 ^ expected_operand2)) begin
                $display("PASS");
                $display("  Outputs: opcode=%h, operand1=%h, operand2=%h",
                         opcode, operand1, operand2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: opcode=%h, operand1=%h, operand2=%h",
                         expected_opcode, expected_operand1, expected_operand2);
                $display("  Got:      opcode=%h, operand1=%h, operand2=%h",
                         opcode, operand1, operand2);
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
        $dumpvars(0,clk, instruction, rst, opcode, operand1, operand2);
    end

endmodule

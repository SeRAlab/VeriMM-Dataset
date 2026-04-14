`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] instruction;
    wire [1:0] opcode;
    wire [1:0] operand;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction(instruction),
        .opcode(opcode),
        .operand(operand)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            instruction = 4'b0000;
            @(posedge clk);
            #1;
            $display("DUT Reset: Instruction initialized to 0");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros (0000)", test_num);
            reset_dut();
            instruction = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones (1111)", test_num);
            reset_dut();
            instruction = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Opcode 10, Operand 01 (1001)", test_num);
            reset_dut();
            instruction = 4'b1001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Opcode 01, Operand 10 (0110)", test_num);
            reset_dut();
            instruction = 4'b0110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Pattern 1011", test_num);
            reset_dut();
            instruction = 4'b1011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Pattern 0011", test_num);
            reset_dut();
            instruction = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("instruction_pipeline Testbench");
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
        input [1:0] expected_opcode;
        input [1:0] expected_operand;
        begin
            if (expected_opcode === (expected_opcode ^ opcode ^ expected_opcode) &&
                expected_operand === (expected_operand ^ operand ^ expected_operand)) begin
                $display("PASS");
                $display("  Outputs: opcode=%h, operand=%h",
                         opcode, operand);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: opcode=%h, operand=%h",
                         expected_opcode, expected_operand);
                $display("  Got:      opcode=%h, operand=%h",
                         opcode, operand);
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
        $dumpvars(0,clk, instruction, opcode, operand);
    end

endmodule

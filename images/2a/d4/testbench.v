`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction;
    reg [4:0] operand1;
    reg [4:0] operand2;
    reg reset;
    wire [4:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction(instruction),
        .operand1(operand1),
        .operand2(operand2),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction = 0;
            operand1 = 0;
            operand2 = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: ADD (10 + 5)");
            reset_dut();
            instruction = OP_ADD;
            operand1 = 5'd10;
            operand2 = 5'd5;
            @(posedge clk);

            instruction = 0; operand1 = 0; operand2 = 0;

            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: SUB (20 - 4)");
            reset_dut();
            instruction = OP_SUB;
            operand1 = 5'd20;
            operand2 = 5'd4;
            @(posedge clk);
            instruction = 0; operand1 = 0; operand2 = 0;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: AND (5'b11001 & 5'b10101)");
            reset_dut();
            instruction = OP_AND;
            operand1 = 5'b11001;
            operand2 = 5'b10101;
            @(posedge clk);
            instruction = 0; operand1 = 0; operand2 = 0;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b10001);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: OR (5'b10000 | 5'b00111)");
            reset_dut();
            instruction = OP_OR;
            operand1 = 5'b10000;
            operand2 = 5'b00111;
            @(posedge clk);
            instruction = 0; operand1 = 0; operand2 = 0;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b10111);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: XOR (5'b10101 ^ 5'b11111)");
            reset_dut();
            instruction = OP_XOR;
            operand1 = 5'b10101;
            operand2 = 5'b11111;
            @(posedge clk);
            instruction = 0; operand1 = 0; operand2 = 0;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: LD (Load value 25)");
            reset_dut();
            instruction = OP_LD;
            operand1 = 5'd25;
            operand2 = 5'd0;
            @(posedge clk);
            instruction = 0; operand1 = 0; operand2 = 0;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: ST (Store value 12)");
            reset_dut();
            instruction = OP_ST;
            operand1 = 5'd0;
            operand2 = 5'd12;
            @(posedge clk);
            instruction = 0; operand1 = 0; operand2 = 0;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: ADD Overflow (31 + 2)");
            reset_dut();
            instruction = OP_ADD;
            operand1 = 5'd31;
            operand2 = 5'd2;
            @(posedge clk);
            instruction = 0; operand1 = 0; operand2 = 0;
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(5'd1);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase 009: SUB Underflow (2 - 5)");
            reset_dut();
            instruction = OP_SUB;
            operand1 = 5'd2;
            operand2 = 5'd5;
            @(posedge clk);
            instruction = 0; operand1 = 0; operand2 = 0;
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(5'd29);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [4:0] expected_result;
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
        $dumpvars(0,clk, instruction, operand1, operand2, reset, result);
    end

endmodule

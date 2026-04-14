`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] opcode;
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg reset;
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
            opcode = NOP;
            operand1 = 0;
            operand2 = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Simple Addition (15 + 25)", test_num);
            reset_dut();


            opcode = ADD;
            operand1 = 8'd15;
            operand2 = 8'd25;
            @(posedge clk);


            opcode = NOP;
            operand1 = 0;
            operand2 = 0;


            repeat (4) @(posedge clk);

            #1 #1;
 check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Simple Subtraction (100 - 30)", test_num);
            reset_dut();

            opcode = SUB;
            operand1 = 8'd100;
            operand2 = 8'd30;
            @(posedge clk);

            opcode = NOP;
            repeat (4) @(posedge clk);

            #1 #1;
 check_outputs(8'd70);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Addition with 8-bit Overflow (200 + 100)", test_num);
            reset_dut();

            opcode = ADD;
            operand1 = 8'd200;
            operand2 = 8'd100;
            @(posedge clk);

            opcode = NOP;
            repeat (4) @(posedge clk);

            #1 #1;
 check_outputs(8'd44);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Negative Result (10 - 20)", test_num);
            reset_dut();

            opcode = SUB;
            operand1 = 8'd10;
            operand2 = 8'd20;
            @(posedge clk);

            opcode = NOP;
            repeat (4) @(posedge clk);

            #1 #1;
 check_outputs(8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Pipeline Throughput Check", test_num);
            reset_dut();


            opcode = ADD; operand1 = 8'd1; operand2 = 8'd1; @(posedge clk);

            opcode = ADD; operand1 = 8'd2; operand2 = 8'd2; @(posedge clk);

            opcode = ADD; operand1 = 8'd3; operand2 = 8'd3; @(posedge clk);

            opcode = ADD; operand1 = 8'd4; operand2 = 8'd4; @(posedge clk);

            opcode = ADD; operand1 = 8'd10; operand2 = 8'd10; @(posedge clk);

            opcode = NOP;

            repeat (4) @(posedge clk);


            #1 #1;
 check_outputs(8'd20);
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
        $dumpvars(0,clk, opcode, operand1, operand2, reset, result);
    end

endmodule

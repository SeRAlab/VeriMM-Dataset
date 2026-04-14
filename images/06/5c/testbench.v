`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction;
    reg reset;
    wire ready;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .instruction(instruction),
        .reset(reset),
        .ready(ready),
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
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: ADD Operation (15 + 25)", test_num);
        reset_dut();
        instruction = gen_inst(OP_ADD, 8'd15, 8'd25);
        @(posedge clk);
        instruction = 32'h0;
        repeat (5) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: SUB Operation (100 - 36)", test_num);
        reset_dut();
        instruction = gen_inst(OP_SUB, 8'd100, 8'd36);
        @(posedge clk);
        instruction = 32'h0;
        repeat (5) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'd64);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: AND Operation (0xAA & 0xF0)", test_num);
        reset_dut();
        instruction = gen_inst(OP_AND, 8'hAA, 8'hF0);
        @(posedge clk);
        instruction = 32'h0;
        repeat (5) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'h000000A0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: OR Operation (0x55 | 0x0F)", test_num);
        reset_dut();
        instruction = gen_inst(OP_OR, 8'h55, 8'h0F);
        @(posedge clk);
        instruction = 32'h0;
        repeat (5) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'h0000005F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: XOR Operation (0xFF ^ 0x33)", test_num);
        reset_dut();
        instruction = gen_inst(OP_XOR, 8'hFF, 8'h33);
        @(posedge clk);
        instruction = 32'h0;
        repeat (5) @(posedge clk);
        #1;

        check_outputs(1'b1, 32'h000000CC);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Pipeline Hazard/Flow (ADD then SUB)", test_num);
        reset_dut();

        instruction = gen_inst(OP_ADD, 8'd10, 8'd10);
        @(posedge clk);

        instruction = gen_inst(OP_SUB, 8'd50, 8'd10);
        @(posedge clk);

        instruction = 32'h0;
        repeat (5) @(posedge clk);

        #1;


        check_outputs(1'b1, 32'd40);
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
        input expected_ready;
        input [31:0] expected_result;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, result=%h",
                         ready, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, result=%h",
                         expected_ready, expected_result);
                $display("  Got:      ready=%b, result=%h",
                         ready, result);
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
        $dumpvars(0,clk, instruction, reset, ready, result);
    end

endmodule

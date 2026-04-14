`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .result_out(result_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_in = NOP;
            @(posedge clk);
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTest Case 001: Basic MOV Operation");
            reset_dut();

            instruction_in = {OP_MOV, 8'h01, 8'h00, 8'hAA};
            @(posedge clk);
            instruction_in = NOP;


            repeat (PIPELINE_LATENCY - 1) @(posedge clk);

            #1;


            check_outputs(32'h000000AA);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Basic ADD Operation");
            reset_dut();

            instruction_in = {OP_ADD, 8'h03, 8'h10, 8'h20};
            @(posedge clk);
            instruction_in = NOP;

            repeat (PIPELINE_LATENCY - 1) @(posedge clk);

            #1;


            check_outputs(32'h00000030);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Basic SUB Operation");
            reset_dut();

            instruction_in = {OP_SUB, 8'h04, 8'h50, 8'h10};
            @(posedge clk);
            instruction_in = NOP;

            repeat (PIPELINE_LATENCY - 1) @(posedge clk);

            #1;


            check_outputs(32'h00000040);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Pipeline Sequence");
            reset_dut();


            instruction_in = {OP_MOV, 8'h01, 8'h00, 8'h01};
            @(posedge clk);
            instruction_in = {OP_MOV, 8'h02, 8'h00, 8'h02};
            @(posedge clk);
            instruction_in = {OP_MOV, 8'h03, 8'h00, 8'h03};
            @(posedge clk);
            instruction_in = NOP;



            repeat (PIPELINE_LATENCY) @(posedge clk);

            #1;


            check_outputs(32'h00000003);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Underflow SUB Operation");
            reset_dut();

            instruction_in = {OP_SUB, 8'h05, 8'h05, 8'h0A};
            @(posedge clk);
            instruction_in = NOP;

            repeat (PIPELINE_LATENCY - 1) @(posedge clk);

            #1;


            check_outputs(32'hFFFFFFF6);
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
        input [31:0] expected_result_out;
        begin
            if (expected_result_out === (expected_result_out ^ result_out ^ expected_result_out)) begin
                $display("PASS");
                $display("  Outputs: result_out=%h",
                         result_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_out=%h",
                         expected_result_out);
                $display("  Got:      result_out=%h",
                         result_out);
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
        $dumpvars(0,clk, instruction_in, reset, result_out);
    end

endmodule

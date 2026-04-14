`timescale 1ns/1ps

module pipeline_processor_tb;

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
    pipeline_processor dut (
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Basic ADD Operation...");
            reset_dut();

            instruction_in = {ADD, 4'd1, 4'd0, 4'd0, 12'd10};
            @(posedge clk);
            instruction_in = NOP;


            repeat (7) @(posedge clk);

            #1;


            check_outputs(32'h0000000A);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Data Forwarding (RAW Hazard)...");
            reset_dut();


            instruction_in = {ADD, 4'd1, 4'd0, 4'd0, 12'd5};
            @(posedge clk);

            instruction_in = {ADD, 4'd2, 4'd1, 4'd0, 12'd5};
            @(posedge clk);
            instruction_in = NOP;


            repeat (8) @(posedge clk);


            #1;



            check_outputs(32'h0000000A);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Load-Use Stall...");
            reset_dut();


            instruction_in = {LOAD, 4'd1, 4'd0, 4'd0, 12'd100};
            @(posedge clk);

            instruction_in = {ADD, 4'd2, 4'd1, 4'd0, 12'd1};
            @(posedge clk);
            instruction_in = NOP;


            repeat (9) @(posedge clk);



            #1;




            check_outputs(32'h00000065);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Pipeline Flush on Jump...");
            reset_dut();


            instruction_in = {JUMP, 4'd0, 4'd0, 4'd0, 12'd50};
            @(posedge clk);

            instruction_in = {ADD, 4'd3, 4'd0, 4'd0, 12'hFFF};
            @(posedge clk);
            instruction_in = NOP;

            repeat (8) @(posedge clk);


            if (result_out != 32'h00000FFF) begin
                pass_count = pass_count + 1;
                $display("  [PASS] Instruction successfully flushed.");
            end else begin
                fail_count = fail_count + 1;
                $display("  [FAIL] Instruction was not flushed!");
            end
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Pipeline Throughput...");
            reset_dut();

            instruction_in = {ADD, 4'd1, 4'd0, 4'd0, 12'd1}; @(posedge clk);
            instruction_in = {ADD, 4'd1, 4'd0, 4'd0, 12'd2}; @(posedge clk);
            instruction_in = {ADD, 4'd1, 4'd0, 4'd0, 12'd3}; @(posedge clk);
            instruction_in = {ADD, 4'd1, 4'd0, 4'd0, 12'd4}; @(posedge clk);
            instruction_in = {ADD, 4'd1, 4'd0, 4'd0, 12'd5}; @(posedge clk);
            instruction_in = NOP;

            repeat (10) @(posedge clk);


            #1;



            check_outputs(32'h00000005);
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

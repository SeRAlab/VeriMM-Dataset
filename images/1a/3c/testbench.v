`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction;
    reg rst;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction(instruction),
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
            instruction = 32'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            $display("System Reset Sequence Complete.");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Simple ADD...");
            reset_dut();

            instruction = {OP_ADD, 8'd10, 8'd20, 8'd03};
            @(posedge clk);
            instruction = 32'h0;


            repeat (4) @(posedge clk);

            #1;


            check_outputs(32'd30);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Simple SUB...");
            reset_dut();

            instruction = {OP_SUB, 8'd50, 8'd20, 8'd03};
            @(posedge clk);
            instruction = 32'h0;

            repeat (4) @(posedge clk);

            #1;


            check_outputs(32'd30);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Data Forwarding (ADD -> ADD)...");
            reset_dut();


            instruction = {OP_ADD, 8'd5, 8'd5, 8'd01};
            @(posedge clk);

            instruction = {OP_ADD, 8'd1, 8'd10, 8'd02};
            @(posedge clk);
            instruction = 32'h0;


            repeat (4) @(posedge clk);

            #1;


            check_outputs(32'd20);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Pipeline Throughput...");
            reset_dut();

            instruction = {OP_ADD, 8'd1, 8'd1, 8'd05}; @(posedge clk);
            instruction = {OP_ADD, 8'd2, 8'd2, 8'd05}; @(posedge clk);
            instruction = {OP_ADD, 8'd3, 8'd3, 8'd05}; @(posedge clk);
            instruction = {OP_ADD, 8'd4, 8'd4, 8'd05}; @(posedge clk);
            instruction = {OP_ADD, 8'd5, 8'd5, 8'd05}; @(posedge clk);
            instruction = 32'h0;


            repeat (4) @(posedge clk);
            #1;

            check_outputs(32'd10);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Mixed Operations Hazard...");
            reset_dut();

            instruction = {OP_ADD, 8'd100, 8'd50, 8'd01}; @(posedge clk);
            instruction = {OP_SUB, 8'd1, 8'd25, 8'd02};   @(posedge clk);
            instruction = 32'h0;

            repeat (4) @(posedge clk);
            #1;

            check_outputs(32'd125);
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
        input [31:0] expected_result;
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
        $dumpvars(0,clk, instruction, rst, result);
    end

endmodule

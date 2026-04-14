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
        end
        endtask
    task testcase001;

        begin
            $display("\nTest Case 001: ADDI R1, R0, 15");
            reset_dut();

            @(posedge clk); #1 instruction = 32'h2001000F;
            @(posedge clk); #1 instruction = 32'h0;
            repeat(4) @(posedge clk);
            #2 #1;
 check_outputs(32'h0000000F);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: ADDI R2, R0, 25");
            reset_dut();

            @(posedge clk); #1 instruction = 32'h20020019;
            @(posedge clk); #1 instruction = 32'h0;
            repeat(4) @(posedge clk);
            #2 #1;
 check_outputs(32'h00000019);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: ADD R3, R1, R2 (15 + 25)");
            reset_dut();

            @(posedge clk); #1 instruction = 32'h2001000F;

            repeat(4) @(posedge clk); #1 instruction = 32'h20020019;

            repeat(4) @(posedge clk); #1 instruction = 32'h00221820;
            @(posedge clk); #1 instruction = 32'h0;
            repeat(4) @(posedge clk);
            #2 #1;
 check_outputs(32'h00000028);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: SUB R4, R2, R1 (25 - 15)");
            reset_dut();
            @(posedge clk); #1 instruction = 32'h2001000F;
            repeat(4) @(posedge clk); #1 instruction = 32'h20020019;
            repeat(4) @(posedge clk); #1 instruction = 32'h00412022;
            @(posedge clk); #1 instruction = 32'h0;
            repeat(4) @(posedge clk);
            #2 #1;
 check_outputs(32'h0000000A);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: AND R5, R1, R2 (15 & 25)");
            reset_dut();
            @(posedge clk); #1 instruction = 32'h2001000F;
            repeat(4) @(posedge clk); #1 instruction = 32'h20020019;
            repeat(4) @(posedge clk); #1 instruction = 32'h00222824;
            @(posedge clk); #1 instruction = 32'h0;
            repeat(4) @(posedge clk);
            #2 #1;
 check_outputs(32'h00000009);
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

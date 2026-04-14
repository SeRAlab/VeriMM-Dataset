`timescale 1ns/1ps

module pipelined_adder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] operand_a;
    reg [23:0] operand_b;
    reg rst;
    wire [23:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_adder dut (
        .clk(clk),
        .operand_a(operand_a),
        .operand_b(operand_b),
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
            operand_a = 24'd0;
            operand_b = 24'd0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Basic Addition (10 + 20)");
            operand_a = 24'd10;
            operand_b = 24'd20;


            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(24'd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Zero Addition");
            operand_a = 24'h000000;
            operand_b = 24'h000000;

            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Max Value Wrap-around");
            operand_a = 24'hFFFFFF;
            operand_b = 24'h000001;

            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Large Values");
            operand_a = 24'h123456;
            operand_b = 24'h654321;

            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(24'h777777);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Alternating Bit Pattern");
            operand_a = 24'hAAAAAA;
            operand_b = 24'h555555;

            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case 006: Half-Scale Addition");
            operand_a = 24'h800000;
            operand_b = 24'h800000;

            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_adder Testbench");
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
        input [23:0] expected_result;
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
        $dumpvars(0,clk, operand_a, operand_b, rst, result);
    end

endmodule

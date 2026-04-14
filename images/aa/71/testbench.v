`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg carry_in;
    reg clk;
    reg [15:0] operand1;
    reg [15:0] operand2;
    wire carry_out;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carry_in(carry_in),
        .clk(clk),
        .operand1(operand1),
        .operand2(operand2),
        .carry_out(carry_out),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        operand1 <= 16'h0;
        operand2 <= 16'h0;
        carry_in <= 1'b0;
        repeat(5) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Simple addition (5 + 10)", test_num);
        operand1 <= 16'h0005;
        operand2 <= 16'h000A;
        carry_in <= 1'b0;

        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 16'h000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Addition with carry_in (FF + 1 + 1)", test_num);
        operand1 <= 16'h00FF;
        operand2 <= 16'h0001;
        carry_in <= 1'b1;

        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 16'h0101);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Max sum without carry_out (FFFE + 1)", test_num);
        operand1 <= 16'hFFFE;
        operand2 <= 16'h0001;
        carry_in <= 1'b0;

        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Generating carry_out (FFFF + 1)", test_num);
        operand1 <= 16'hFFFF;
        operand2 <= 16'h0001;
        carry_in <= 1'b0;

        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Max inputs (FFFF + FFFF + 1)", test_num);
        operand1 <= 16'hFFFF;
        operand2 <= 16'hFFFF;
        carry_in <= 1'b1;

        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Alternating bits (AAAA + 5555)", test_num);
        operand1 <= 16'hAAAA;
        operand2 <= 16'h5555;
        carry_in <= 1'b0;

        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Zeros (0 + 0 + 0)", test_num);
        operand1 <= 16'h0000;
        operand2 <= 16'h0000;
        carry_in <= 1'b0;

        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_carry_out;
        input [15:0] expected_sum;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum=%h",
                         carry_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum=%h",
                         expected_carry_out, expected_sum);
                $display("  Got:      carry_out=%b, sum=%h",
                         carry_out, sum);
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
        $dumpvars(0,carry_in, clk, operand1, operand2, carry_out, sum);
    end

endmodule

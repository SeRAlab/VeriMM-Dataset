`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire carry_out;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
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
        A <= 4'b0;
        B <= 4'b0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        A <= 4'sd3; B <= 4'sd2;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'sb0101);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        A <= -4'sd1; B <= -4'sd1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'sb1110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        A <= 4'sd7; B <= 4'sd1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'sb1000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        A <= -4'sd8; B <= -4'sd1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'sb0111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        A <= 4'sd0; B <= 4'sd0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'sb0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        A <= -4'sd8; B <= -4'sd8;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'sb0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        A <= 4'sd7; B <= 4'sd7;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'sb1110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        A <= -4'sd5; B <= 4'sd2;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'sb1101);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        A <= -4'sd1; B <= 4'sd1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'sb0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();
        A <= 4'sd5; B <= -4'sd3;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'sb0010);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_sum;
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
        $dumpvars(0,A, B, clk, carry_out, sum);
    end

endmodule

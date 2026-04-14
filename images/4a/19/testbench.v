`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg RST;
    reg clk;
    reg sub;
    wire [3:0] Q;
    wire [3:0] final_output;
    wire overflow;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .RST(RST),
        .clk(clk),
        .sub(sub),
        .Q(Q),
        .final_output(final_output),
        .overflow(overflow),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        RST = 0;
        forever #5 RST = ~RST;
    end

        task reset_dut;

    begin
        RST = 0;
        A = 0;
        B = 0;
        sub = 0;
        #12;
        RST = 1;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Addition (3 + 2)", test_num);
        reset_dut();
        A = 4'd3; B = 4'd2; sub = 1'b0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'd1, 4'd6, 1'b0, 4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition Overflow (7 + 1)", test_num);
        reset_dut();
        A = 4'b0111; B = 4'b0001; sub = 1'b0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'd1, 4'd9, 1'b1, 4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Subtraction (2 - 5)", test_num);
        reset_dut();
        A = 4'd2; B = 4'd5; sub = 1'b1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'd1, 4'd14, 1'b0, 4'd13);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction Overflow (-7 - 2)", test_num);
        reset_dut();
        A = 4'b1001; B = 4'b0010; sub = 1'b1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'd1, 4'd8, 1'b1, 4'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multi-cycle Counter", test_num);
        reset_dut();
        A = 4'd1; B = 4'd1; sub = 1'b0;
        repeat (3) @(posedge clk);
        #1;

        #1;


        check_outputs(4'd3, 4'd5, 1'b0, 4'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Async Reset Mid-operation", test_num);
        reset_dut();
        A = 4'd0; B = 4'd0; sub = 1'b0;
        repeat (5) @(posedge clk);
        RST = 0;
        #1;

        #1;


        check_outputs(4'd0, 4'd0, 1'b0, 4'd0);
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
        input [3:0] expected_Q;
        input [3:0] expected_final_output;
        input expected_overflow;
        input [3:0] expected_sum;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, final_output=%h, overflow=%b, sum=%h",
                         Q, final_output, overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, final_output=%h, overflow=%b, sum=%h",
                         expected_Q, expected_final_output, expected_overflow, expected_sum);
                $display("  Got:      Q=%h, final_output=%h, overflow=%b, sum=%h",
                         Q, final_output, overflow, sum);
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
        $dumpvars(0,A, B, RST, clk, sub, Q, final_output, overflow, sum);
    end

endmodule

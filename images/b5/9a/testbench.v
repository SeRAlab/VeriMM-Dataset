`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg op;
    wire overflow;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .op(op),
        .overflow(overflow),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'd0;
            B = 4'd0;
            op = 1'b0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 4'd5;
            B = 4'd3;
            op = 1'b0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 5 + 3", test_num);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 4'd12;
            B = 4'd7;
            op = 1'b0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 12 + 7 (Overflow)", test_num);
            #1;

            check_outputs(1'b1, 4'd3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 4'd15;
            B = 4'd0;
            op = 1'b0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 15 + 0 (Boundary)", test_num);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 4'd10;
            B = 4'd4;
            op = 1'b1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 10 - 4", test_num);
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 4'd7;
            B = 4'd7;
            op = 1'b1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 7 - 7", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 4'd2;
            B = 4'd5;
            op = 1'b1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 2 - 5 (Underflow case)", test_num);
            #1;

            check_outputs(1'b0, 4'd13);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 4'd8;
            B = 4'd8;
            op = 1'b0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 8 + 8 (Exact Overflow)", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
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
        input expected_overflow;
        input [3:0] expected_result;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
        $dumpvars(0,A, B, clk, op, overflow, result);
    end

endmodule

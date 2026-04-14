`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] OP;
    reg clk;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OP(OP),
        .clk(clk),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            OP = 0;

            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Addition (5 + 3)");
            reset_dut();
            A = 4'd5; B = 4'd3; OP = 3'b000;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Subtraction (10 - 4)");
            reset_dut();
            A = 4'd10; B = 4'd4; OP = 3'b001;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Bitwise AND (12 & 10)");
            reset_dut();
            A = 4'b1100; B = 4'b1010; OP = 3'b010;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Bitwise OR (12 | 10)");
            reset_dut();
            A = 4'b1100; B = 4'b1010; OP = 3'b011;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bitwise XOR (12 ^ 10)");
            reset_dut();
            A = 4'b1100; B = 4'b1010; OP = 3'b100;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Addition Overflow (15 + 1)");
            reset_dut();
            A = 4'd15; B = 4'd1; OP = 3'b000;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Subtraction Underflow (2 - 5)");
            reset_dut();
            A = 4'd2; B = 4'd5; OP = 3'b001;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd13);
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
        input [3:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,A, B, OP, clk, Y);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

    begin
        A = 4'b0;
        B = 4'b0;

        repeat(2) @(posedge C);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Addition (3 + 4)", test_num);
        A = 4'd3;
        B = 4'd4;


        @(negedge C);
        #1;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Subtraction (10 - 3)", test_num);
        A = 4'd10;
        B = 4'd3;


        @(posedge C);
        #1;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Addition Overflow (12 + 5 = 17 -> 1)", test_num);
        A = 4'd12;
        B = 4'd5;
        @(negedge C);
        #1;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction Underflow (4 - 6 = -2 -> 14)", test_num);
        A = 4'd4;
        B = 4'd6;
        @(posedge C);
        #1;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Identity (15 + 0)", test_num);
        A = 4'd15;
        B = 4'd0;
        @(negedge C);
        #1;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Max Value Subtraction (15 - 15)", test_num);
        A = 4'd15;
        B = 4'd15;
        @(posedge C);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying trigger timing", test_num);
        A = 4'd1; B = 4'd1;
        @(negedge C);
        A = 4'd8; B = 4'd2;
        @(posedge C);
        #1;
        #1;

        check_outputs(4'd6);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,A, B, C, out);
    end

endmodule

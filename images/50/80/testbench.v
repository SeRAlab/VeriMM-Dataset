`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg ctrl;
    reg resetn;
    wire [3:0] D;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .ctrl(ctrl),
        .resetn(resetn),
        .D(D),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            A = 0;
            B = 0;
            ctrl = 0;
            @(posedge clk);
            #1;
            resetn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Verification", test_num);
            resetn = 0;
            A = 4'hF;
            B = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h0);
            resetn = 1;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Basic Addition (5 + 3)", test_num);
            A = 4'd5;
            B = 4'd3;
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Addition with Overflow (12 + 6)", test_num);
            A = 4'd12;
            B = 4'd6;
            ctrl = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Basic Subtraction (10 - 4)", test_num);
            A = 4'd10;
            B = 4'd4;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6, 4'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Subtraction Underflow (3 - 5)", test_num);
            A = 4'd3;
            B = 4'd5;
            ctrl = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hE, 4'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Max Addition (15 + 15)", test_num);
            A = 4'hF;
            B = 4'hF;
            ctrl = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'hE);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %03d: Subtraction Resulting in Zero (7 - 7)", test_num);
            A = 4'd7;
            B = 4'd7;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h0);
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
        input [3:0] expected_D;
        input [3:0] expected_S;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: D=%h, S=%h",
                         D, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, S=%h",
                         expected_D, expected_S);
                $display("  Got:      D=%h, S=%h",
                         D, S);
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
        $dumpvars(0,A, B, clk, ctrl, resetn, D, S);
    end

endmodule

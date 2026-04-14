`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg reset;
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
        .reset(reset),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        A = 0;
        B = 0;
        @(posedge clk);
        #1;
        reset = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic addition (2 + 3)", test_num);
        reset_dut();
        A = 4'd2;
        B = 4'd3;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero addition (0 + 0)", test_num);
        reset_dut();
        A = 4'd0;
        B = 4'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max values addition (15 + 1)", test_num);
        reset_dut();
        A = 4'hf;
        B = 4'h1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow addition (8 + 8)", test_num);
        reset_dut();
        A = 4'h8;
        B = 4'h8;
        @(posedge clk);
        #2;

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-range addition (7 + 4)", test_num);
        reset_dut();
        A = 4'd7;
        B = 4'd4;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'd11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset functionality (reset low during operation)", test_num);
        reset_dut();
        A = 4'hA;
        B = 4'h5;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max overflow (15 + 15)", test_num);
        reset_dut();
        A = 4'hf;
        B = 4'hf;
        @(posedge clk);
        #2;

        #1;


        check_outputs(4'he);
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
        input [3:0] expected_S;
        begin
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
        $dumpvars(0,A, B, clk, reset, S);
    end

endmodule

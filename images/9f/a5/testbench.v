`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] K_over_S;
    reg clk;
    reg [63:0] log_lambda_down;
    reg [63:0] log_lambda_up;
    reg nrst;
    reg start;
    wire [63:0] v_ex;
    wire [12:0] wraddr;
    wire wren;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .K_over_S(K_over_S),
        .clk(clk),
        .log_lambda_down(log_lambda_down),
        .log_lambda_up(log_lambda_up),
        .nrst(nrst),
        .start(start),
        .v_ex(v_ex),
        .wraddr(wraddr),
        .wren(wren)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        nrst = 0;
        start = 0;
        log_lambda_up = 64'h0;
        log_lambda_down = 64'h0;
        K_over_S = 64'h0;
        @(posedge clk);
        #1 nrst = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Basic functional check (Positive Difference)", test_num);

        log_lambda_up = 64'd100;
        log_lambda_down = 64'd40;
        K_over_S = 64'd10;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(64'd600, 13'h0000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Negative Difference scaling", test_num);

        log_lambda_up = 64'd40;
        log_lambda_down = 64'd100;
        K_over_S = 64'd2;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFF88, 13'h0000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Scaling with zero", test_num);

        log_lambda_up = 64'd1000;
        log_lambda_down = 64'd500;
        K_over_S = 64'd0;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(64'h0, 13'h0000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Large value truncation", test_num);

        log_lambda_up = 64'd2;
        log_lambda_down = 64'd0;
        K_over_S = 64'h8000000000000000;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        repeat(1) @(posedge clk);
        #1;

        #1;


        check_outputs(64'h0, 13'h0000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Start signal remains low", test_num);
        log_lambda_up = 64'hA;
        log_lambda_down = 64'h5;
        K_over_S = 64'h2;
        start = 0;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(64'h0, 13'h0000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Zero difference check", test_num);
        log_lambda_up = 64'hFFFFFFFFFFFFFFFF;
        log_lambda_down = 64'hFFFFFFFFFFFFFFFF;
        K_over_S = 64'hABCDE;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(64'h0, 13'h0000, 1'b1);
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
        input [63:0] expected_v_ex;
        input [12:0] expected_wraddr;
        input expected_wren;
        begin
            if (expected_v_ex === (expected_v_ex ^ v_ex ^ expected_v_ex) &&
                expected_wraddr === (expected_wraddr ^ wraddr ^ expected_wraddr) &&
                expected_wren === (expected_wren ^ wren ^ expected_wren)) begin
                $display("PASS");
                $display("  Outputs: v_ex=%h, wraddr=%h, wren=%b",
                         v_ex, wraddr, wren);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_ex=%h, wraddr=%h, wren=%b",
                         expected_v_ex, expected_wraddr, expected_wren);
                $display("  Got:      v_ex=%h, wraddr=%h, wren=%b",
                         v_ex, wraddr, wren);
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
        $dumpvars(0,K_over_S, clk, log_lambda_down, log_lambda_up, nrst, start, v_ex, wraddr, wren);
    end

endmodule

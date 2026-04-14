`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire GTE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .GTE(GTE)
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
        @(posedge clk);
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Positive A > B (3 >= 2)", test_num);
        @(negedge clk);
        A = 4'sd3; B = 4'sd2;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Positive A < B (1 >= 4)", test_num);
        @(negedge clk);
        A = 4'sd1; B = 4'sd4;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Positive A == B (5 >= 5)", test_num);
        @(negedge clk);
        A = 4'sd5; B = 4'sd5;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Negative A > B (-2 >= -5)", test_num);
        @(negedge clk);
        A = -4'sd2; B = -4'sd5;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Negative A < B (-7 >= -3)", test_num);
        @(negedge clk);
        A = -4'sd7; B = -4'sd3;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Negative A == B (-8 >= -8)", test_num);
        @(negedge clk);
        A = -4'sd8; B = -4'sd8;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Positive A > Negative B (1 >= -1)", test_num);
        @(negedge clk);
        A = 4'sd1; B = -4'sd1;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Negative A < Positive B (-1 >= 1)", test_num);
        @(negedge clk);
        A = -4'sd1; B = 4'sd1;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Max Pos vs Min Neg (7 >= -8)", test_num);
        @(negedge clk);
        A = 4'sd7; B = -4'sd8;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Zero vs Negative (0 >= -1)", test_num);
        @(negedge clk);
        A = 4'sd0; B = -4'sd1;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
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
        input expected_GTE;
        begin
            if (expected_GTE === (expected_GTE ^ GTE ^ expected_GTE)) begin
                $display("PASS");
                $display("  Outputs: GTE=%b",
                         GTE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GTE=%b",
                         expected_GTE);
                $display("  Got:      GTE=%b",
                         GTE);
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
        $dumpvars(0,A, B, clk, GTE);
    end

endmodule

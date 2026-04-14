`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .sel(sel),
        .out(out)
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
        sel = 0;
        repeat(4) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Unsigned Small (10 * 5)", test_num);
        A = 8'd10; B = 8'd5; sel = 0;
        repeat(4) @(posedge clk);
        #1;

        check_outputs(16'd50);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Unsigned Large (255 * 10)", test_num);
        A = 8'hFF; B = 8'd10; sel = 0;
        repeat(4) @(posedge clk);
        #1;

        check_outputs(16'h09F6);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Unsigned Max (255 * 255)", test_num);
        A = 8'hFF; B = 8'hFF; sel = 0;
        repeat(4) @(posedge clk);
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Signed Positive (10 * 5)", test_num);
        A = 8'd10; B = 8'd5; sel = 1;
        repeat(4) @(posedge clk);
        #1;

        check_outputs(16'd50);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Signed Neg * Pos (-1 * 5)", test_num);
        A = 8'hFF; B = 8'd5; sel = 1;
        repeat(4) @(posedge clk);
        #1;

        check_outputs(16'hFFFB);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Signed Pos * Neg (5 * -1)", test_num);
        A = 8'd5; B = 8'hFF; sel = 1;
        repeat(4) @(posedge clk);
        #1;

        check_outputs(16'hFFFB);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test %0d: Signed Neg * Neg (-1 * -1)", test_num);
        A = 8'hFF; B = 8'hFF; sel = 1;
        repeat(4) @(posedge clk);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Test %0d: Signed Max Neg * Pos (-128 * 2)", test_num);
        A = 8'h80; B = 8'd2; sel = 1;
        repeat(4) @(posedge clk);
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        $display("Test %0d: Signed Max Neg Squared (-128 * -128)", test_num);
        A = 8'h80; B = 8'h80; sel = 1;
        repeat(4) @(posedge clk);
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = 10;
        $display("Test %0d: Zero Test (0 * 255)", test_num);
        A = 8'h00; B = 8'hFF; sel = 0;
        repeat(4) @(posedge clk);
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_out;
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
        $dumpvars(0,A, B, clk, sel, out);
    end

endmodule

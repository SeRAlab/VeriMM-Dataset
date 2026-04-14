`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] input0;
    reg [31:0] input1;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input0(input0),
        .input1(input1),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        input0 <= 32'h0;
        input1 <= 32'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Simple Addition (100 + 250)", test_num);
        input0 <= 32'd100;
        input1 <= 32'd250;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Zero Addition (0 + 0)", test_num);
        input0 <= 32'h0;
        input1 <= 32'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Boundary Overflow (MAX + 1)", test_num);
        input0 <= 32'hFFFFFFFF;
        input1 <= 32'h00000001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bit Patterns", test_num);
        input0 <= 32'hAAAAAAAA;
        input1 <= 32'h55555555;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Large Value Sum", test_num);
        input0 <= 32'h12345678;
        input1 <= 32'h87654321;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h99999999);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Max + Max (Wrap)", test_num);
        input0 <= 32'hFFFFFFFF;
        input1 <= 32'hFFFFFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFE);
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
        input [31:0] expected_out;
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
        $dumpvars(0,clk, input0, input1, out);
    end

endmodule

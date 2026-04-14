`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in1;
    reg [3:0] in2;
    reg rst;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        rst = 1;
        in1 = 0;
        in2 = 0;
        @(negedge clk);
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Addition (5 + 7)", test_num);
        reset_dut();
        in1 = 4'd5;
        in2 = 4'd7;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd12);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Values (15 + 15)", test_num);
        reset_dut();
        in1 = 4'd15;
        in2 = 4'd15;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
        reset_dut();
        in1 = 4'd0;
        in2 = 4'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry Bit Test (8 + 8)", test_num);
        reset_dut();
        in1 = 4'd8;
        in2 = 4'd8;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Priority (Reset high while inputs have values)", test_num);
        reset_dut();
        in1 = 4'd10;
        in2 = 4'd5;
        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit Pattern Addition (10 + 5)", test_num);
        reset_dut();
        in1 = 4'hA;
        in2 = 4'h5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'h0F);
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
        input [4:0] expected_out;
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
        $dumpvars(0,clk, in1, in2, rst, out);
    end

endmodule

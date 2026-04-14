`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    wire ov;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .ov(ov),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        a = 0;
        b = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Behavior", test_num);
        reset_dut();


        #1;



        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive + Positive (No Overflow)", test_num);
        reset_dut();
        a = 8'd10;
        b = 8'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative + Negative (No Overflow)", test_num);
        reset_dut();
        a = -8'd15;
        b = -8'd35;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, -8'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive + Negative", test_num);
        reset_dut();
        a = 8'd50;
        b = -8'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive Overflow", test_num);
        reset_dut();
        a = 8'd120;
        b = 8'd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, -8'd126);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative Overflow", test_num);
        reset_dut();
        a = -8'sd100;
        b = -8'sd40;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'sd116);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Positive Boundary Overflow", test_num);
        reset_dut();
        a = 8'sd127;
        b = 8'sd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, -8'sd128);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Negative Boundary Overflow", test_num);
        reset_dut();
        a = -8'sd128;
        b = -8'sd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'sd127);
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
        input expected_ov;
        input [7:0] expected_s;
        begin
            if (expected_ov === (expected_ov ^ ov ^ expected_ov) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: ov=%b, s=%h",
                         ov, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ov=%b, s=%h",
                         expected_ov, expected_s);
                $display("  Got:      ov=%b, s=%h",
                         ov, s);
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
        $dumpvars(0,a, b, clk, reset, ov, s);
    end

endmodule

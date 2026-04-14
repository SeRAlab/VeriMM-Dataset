`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg ena;
    wire [15:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .ena(ena),
        .Z(Z)
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
        ena = 1;
        @(posedge clk);
        #1;
        ena = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Multiplication (10 * 5)", test_num);
        reset_dut();
        A = 8'd10;
        B = 8'd5;
        ena = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd50);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Values (255 * 255)", test_num);
        reset_dut();
        A = 8'hFF;
        B = 8'hFF;
        ena = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Property (255 * 0)", test_num);
        reset_dut();
        A = 8'd255;
        B = 8'd0;
        ena = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Powers of 2 (128 * 2)", test_num);
        reset_dut();
        A = 8'd128;
        B = 8'd2;
        ena = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable Signal Low Check", test_num);
        reset_dut();

        A = 8'd20;
        B = 8'd4;
        ena = 1;
        @(posedge clk);
        #1;


        A = 8'd10;
        B = 8'd10;
        ena = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'd80);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Prime Numbers (13 * 17)", test_num);
        reset_dut();
        A = 8'd13;
        B = 8'd17;
        ena = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd221);
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
        input [15:0] expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
        $dumpvars(0,A, B, clk, ena, Z);
    end

endmodule

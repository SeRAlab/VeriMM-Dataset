`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Ax;
    reg [15:0] Ay;
    reg [15:0] Az;
    reg [45:0] Bx;
    reg [45:0] By;
    reg [45:0] Bz;
    reg clk;
    wire [63:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ax(Ax),
        .Ay(Ay),
        .Az(Az),
        .Bx(Bx),
        .By(By),
        .Bz(Bz),
        .clk(clk),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Ax = 0;
            Ay = 0;
            Az = 0;
            Bx = 0;
            By = 0;
            Bz = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Simple Dot Product", test_num);
            Ax = 16'd2;
            Bx = 46'd5;
            Ay = 16'd3;
            By = 46'd6;
            Az = 16'd4;
            Bz = 46'd7;

            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'h38);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: All Zeros", test_num);
            Ax = 0; Bx = 0; Ay = 0; By = 0; Az = 0; Bz = 0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Large Input Values", test_num);

            Ax = 16'hFFFF;
            Bx = 46'h1;
            Ay = 16'h0;
            By = 0;
            Az = 16'h0;
            Bz = 0;

            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Single Component High Bits", test_num);
            Ax = 16'h1;
            Bx = 46'h200000000000;
            Ay = 0; By = 0; Az = 0; Bz = 0;

            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'h200000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Accumulation Verification", test_num);
            Ax = 16'h00FF;
            Bx = 46'h100;
            Ay = 16'h00FF;
            By = 46'h100;
            Az = 16'h00FF;
            Bz = 46'h100;

            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'h2FD00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Max Range Check", test_num);

            Ax = 16'hFFFF;
            Bx = 46'h3FFFFFFFFFFF;
            Ay = 16'hFFFF;
            By = 46'h3FFFFFFFFFFF;
            Az = 16'hFFFF;
            Bz = 46'h3FFFFFFFFFFF;




            repeat (5) @(posedge clk);
            #1;

            check_outputs(64'hBFFCFFFFFFF60003);
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
        input [63:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
        $dumpvars(0,Ax, Ay, Az, Bx, By, Bz, clk, C);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Ax;
    reg [15:0] Ay;
    reg [15:0] Az;
    reg [15:0] Bx;
    reg [15:0] By;
    reg [15:0] Bz;
    reg clk;
    wire [32:0] Cx;
    wire [32:0] Cy;
    wire [32:0] Cz;

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
        .Cx(Cx),
        .Cy(Cy),
        .Cz(Cz)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Ax = 0; Ay = 0; Az = 0;
            Bx = 0; By = 0; Bz = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Zero Vectors");
            reset_dut();
            Ax = 0; Ay = 0; Az = 0;
            Bx = 0; By = 0; Bz = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(33'd0, 33'd0, 33'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Basis Vectors i x j");
            reset_dut();
            Ax = 16'd1; Ay = 16'd0; Az = 16'd0;
            Bx = 16'd0; By = 16'd1; Bz = 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(33'd0, 33'd0, 33'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Basis Vectors j x i");
            reset_dut();
            Ax = 16'd0; Ay = 16'd1; Az = 16'd0;
            Bx = 16'd1; By = 16'd0; Bz = 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(33'd0, 33'd0, -33'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Parallel Vectors");
            reset_dut();
            Ax = 16'd10; Ay = 16'd20; Az = 16'd30;
            Bx = 16'd20; By = 16'd40; Bz = 16'd60;
            @(posedge clk);
            #1;
            #1;

            check_outputs(33'd0, 33'd0, 33'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Negative Components");
            reset_dut();
            Ax = -16'd5; Ay = 16'd10; Az = -16'd2;
            Bx = 16'd4;  By = -16'd3; Bz = 16'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(33'sd4, -33'sd3, -33'sd25);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Large Values");
            reset_dut();
            Ax = 16'h7FFF; Ay = 16'd0;      Az = 16'h7FFF;
            Bx = 16'd0;      By = 16'h7FFF; Bz = 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-33'sd1073676289, 33'sd0, 33'sd1073676289);
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
        input [32:0] expected_Cx;
        input [32:0] expected_Cy;
        input [32:0] expected_Cz;
        begin
            if (expected_Cx === (expected_Cx ^ Cx ^ expected_Cx) &&
                expected_Cy === (expected_Cy ^ Cy ^ expected_Cy) &&
                expected_Cz === (expected_Cz ^ Cz ^ expected_Cz)) begin
                $display("PASS");
                $display("  Outputs: Cx=%h, Cy=%h, Cz=%h",
                         Cx, Cy, Cz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cx=%h, Cy=%h, Cz=%h",
                         expected_Cx, expected_Cy, expected_Cz);
                $display("  Got:      Cx=%h, Cy=%h, Cz=%h",
                         Cx, Cy, Cz);
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
        $dumpvars(0,Ax, Ay, Az, Bx, By, Bz, clk, Cx, Cy, Cz);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [27:0] Ax;
    reg [27:0] Ay;
    reg [27:0] Az;
    reg [27:0] Bx;
    reg [27:0] By;
    reg [27:0] Bz;
    reg clk;
    wire [28:0] Cx;
    wire [28:0] Cy;
    wire [28:0] Cz;

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
        Ax = 28'h0;
        Ay = 28'h0;
        Az = 28'h0;
        Bx = 28'h0;
        By = 28'h0;
        Bz = 28'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        Ax = 28'h0; Ay = 28'h0; Az = 28'h0;
        Bx = 28'h0; By = 28'h0; Bz = 28'h0;
        @(posedge clk); #1;
        #1;

        check_outputs(29'h00000000, 29'h00000000, 29'h00000000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Positive Subtraction", test_num);
        Ax = 28'd1000; Ay = 28'd500;  Az = 28'd250;
        Bx = 28'd400;  By = 28'd200;  Bz = 28'd100;
        @(posedge clk); #1;
        #1;

        check_outputs(29'd600, 29'd300, 29'd150);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Negative Result", test_num);
        Ax = 28'h0000000; Ay = 28'h0000000; Az = 28'h0000000;
        Bx = 28'h0000001; By = 28'h0000002; Bz = 28'h0000003;
        @(posedge clk); #1;

        #1;


        check_outputs(29'h1FFFFFFF, 29'h1FFFFFFE, 29'h1FFFFFFD);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Signed Input Subtraction (Negative minus Negative)", test_num);
        Ax = 28'hFFFFFFF; Ay = 28'hFFFFFFF; Az = 28'hFFFFFFF;
        Bx = 28'hFFFFFFF; By = 28'hFFFFFFF; Bz = 28'hFFFFFFF;
        @(posedge clk); #1;
        #1;

        check_outputs(29'h00000000, 29'h00000000, 29'h00000000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Value (Max Pos - Max Neg)", test_num);
        Ax = 28'h7FFFFFF; Ay = 28'h7FFFFFF; Az = 28'h7FFFFFF;
        Bx = 28'h8000000; By = 28'h8000000; Bz = 28'h8000000;
        @(posedge clk); #1;

        #1;


        check_outputs(29'h0FFFFFFF, 29'h0FFFFFFF, 29'h0FFFFFFF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Value (Max Neg - Max Pos)", test_num);
        Ax = 28'h8000000; Ay = 28'h8000000; Az = 28'h8000000;
        Bx = 28'h7FFFFFF; By = 28'h7FFFFFF; Bz = 28'h7FFFFFF;
        @(posedge clk); #1;

        #1;


        check_outputs(29'h10000001, 29'h10000001, 29'h10000001);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Sign Extension Check", test_num);
        Ax = 28'h8000000;
        Ay = 28'hFFFFFFF;
        Az = 28'h0000000;
        Bx = 28'hFFFFFFF;
        By = 28'h8000000;
        Bz = 28'h7FFFFFF;
        @(posedge clk); #1;



        #1;




        check_outputs(29'h18000001, 29'h07FFFFFF, 29'h18000001);
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
        input [28:0] expected_Cx;
        input [28:0] expected_Cy;
        input [28:0] expected_Cz;
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

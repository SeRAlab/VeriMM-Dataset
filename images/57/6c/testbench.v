`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Ax;
    reg [15:0] Ay;
    reg [15:0] Az;
    reg clk;
    reg [15:0] m11;
    reg [15:0] m12;
    reg [15:0] m13;
    reg [15:0] m21;
    reg [15:0] m22;
    reg [15:0] m23;
    reg [15:0] m31;
    reg [15:0] m32;
    reg [15:0] m33;
    wire [15:0] Cx;
    wire [15:0] Cy;
    wire [15:0] Cz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ax(Ax),
        .Ay(Ay),
        .Az(Az),
        .clk(clk),
        .m11(m11),
        .m12(m12),
        .m13(m13),
        .m21(m21),
        .m22(m22),
        .m23(m23),
        .m31(m31),
        .m32(m32),
        .m33(m33),
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
            m11 = 0; m12 = 0; m13 = 0;
            m21 = 0; m22 = 0; m23 = 0;
            m31 = 0; m32 = 0; m33 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Identity Matrix");
            Ax = 16'd10; Ay = 16'd20; Az = 16'd30;
            m11 = 16'd1; m12 = 16'd0; m13 = 16'd0;
            m21 = 16'd0; m22 = 16'd1; m23 = 16'd0;
            m31 = 16'd0; m32 = 16'd0; m33 = 16'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10, 16'd20, 16'd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Zero Matrix");
            Ax = 16'hFFFF; Ay = 16'h1234; Az = 16'hABCD;
            m11 = 0; m12 = 0; m13 = 0;
            m21 = 0; m22 = 0; m23 = 0;
            m31 = 0; m32 = 0; m33 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0, 16'd0, 16'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Scalar Scaling (x5)");
            Ax = 16'd2; Ay = 16'd4; Az = 16'd6;
            m11 = 5; m12 = 0; m13 = 0;
            m21 = 0; m22 = 5; m23 = 0;
            m31 = 0; m32 = 0; m33 = 5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10, 16'd20, 16'd30);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: All Ones Matrix");
            Ax = 16'd100; Ay = 16'd200; Az = 16'd300;
            m11 = 1; m12 = 1; m13 = 1;
            m21 = 1; m22 = 1; m23 = 1;
            m31 = 1; m32 = 1; m33 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd600, 16'd600, 16'd600);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Mixed Weighted Sum");
            Ax = 16'd1; Ay = 16'd2; Az = 16'd3;
            m11 = 1; m12 = 2; m13 = 3;
            m21 = 4; m22 = 5; m23 = 6;
            m31 = 7; m32 = 8; m33 = 9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd30, 16'd36, 16'd42);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case 006: Swap Ay and Az");
            Ax = 16'd5; Ay = 16'd10; Az = 16'd15;
            m11 = 1; m12 = 0; m13 = 0;
            m21 = 0; m22 = 0; m23 = 1;
            m31 = 0; m32 = 1; m33 = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'd5, 16'd15, 16'd10);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case 007: Larger values");
            Ax = 16'd100; Ay = 16'd100; Az = 16'd100;
            m11 = 100; m21 = 100; m31 = 100;
            m12 = 50;  m22 = 50;  m32 = 50;
            m13 = 10;  m23 = 10;  m33 = 10;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'd30000, 16'd15000, 16'd3000);
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
        input [15:0] expected_Cx;
        input [15:0] expected_Cy;
        input [15:0] expected_Cz;
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
        $dumpvars(0,Ax, Ay, Az, clk, m11, m12, m13, m21, m22, m23, m31, m32, m33, Cx, Cy, Cz);
    end

endmodule

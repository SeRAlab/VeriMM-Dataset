`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [28:0] Ax;
    reg [28:0] Ay;
    reg [28:0] Az;
    reg [32:0] Bx;
    reg [32:0] By;
    reg [32:0] Bz;
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
            Ax = 0; Ay = 0; Az = 0;
            Bx = 0; By = 0; Bz = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            Ax = 0; Ay = 0; Az = 0;
            Bx = 0; By = 0; Bz = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Integers", test_num);
            reset_dut();
            Ax = 29'd10; Bx = 33'd5;
            Ay = 29'd20; By = 33'd4;
            Az = 29'd30; Bz = 33'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hDC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: X Component Only", test_num);
            reset_dut();
            Ax = 29'h1000; Bx = 33'h2000;
            Ay = 0; By = 0;
            Az = 0; Bz = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h2000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Y Component Only", test_num);
            reset_dut();
            Ax = 0; Bx = 0;
            Ay = 29'h1000; By = 33'h2000;
            Az = 0; Bz = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h2000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Z Component Only", test_num);
            reset_dut();
            Ax = 0; Bx = 0;
            Ay = 0; By = 0;
            Az = 29'h1000; Bz = 33'h2000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h2000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values", test_num);
            reset_dut();
            Ax = 29'h1FFFFFFF; Bx = 33'h1FFFFFFFF;
            Ay = 29'h1FFFFFFF; By = 33'h1FFFFFFFF;
            Az = 29'h1FFFFFFF; Bz = 33'h1FFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hBFFFFFFF80000003);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Values", test_num);
            reset_dut();
            Ax = 29'h1234567; Bx = 33'h87654321;
            Ay = 29'h7654321; By = 33'h12345678;
            Az = 29'h5555555; Bz = 33'hAAAAAAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h04AE9032546D29AD);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] w0i;
    reg [31:0] w0r;
    reg [15:0] xi;
    reg [15:0] xr;
    reg [15:0] yi;
    reg [15:0] yr;
    wire [15:0] ai;
    wire [15:0] ar;
    wire [15:0] bi;
    wire [15:0] br;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w0i(w0i),
        .w0r(w0r),
        .xi(xi),
        .xr(xr),
        .yi(yi),
        .yr(yr),
        .ai(ai),
        .ar(ar),
        .bi(bi),
        .br(br)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Positive Values", test_num);
            xr = 16'sd10; xi = 16'sd5;
            yr = 16'sd3;  yi = 16'sd2;
            w0r = 32'sd1000; w0i = 32'sd2000;




            #1;





            check_outputs(16'sd5, 16'sd13, 16'sd5, 16'sd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Negative and Mixed Sign Values", test_num);
            xr = -16'sd50; xi = 16'sd20;
            yr = 16'sd30;  yi = -16'sd10;
            w0r = 32'shFFFF_FFFF; w0i = 32'sh0000_0000;




            #1;





            check_outputs(16'sd20, -16'sd20, 16'sd20, -16'sd80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Zero Values and Weight Independence", test_num);
            xr = 16'sd0; xi = -16'sd500;
            yr = 16'sd0; yi = 16'sd1000;
            w0r = 32'sh1234_5678; w0i = 32'sh8765_4321;




            #1;





            check_outputs(-16'sd500, 16'sd0, -16'sd500, 16'sd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Positive Sum Overflow (16-bit wrap)", test_num);
            xr = 16'sd32760; xi = 16'sd1;
            yr = 16'sd10;    yi = 16'sd2;
            w0r = 32'sd0;    w0i = 32'sd0;




            #1;





            check_outputs(16'sd1, -16'sd32766, 16'sd1, 16'sd32750);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Negative Difference Overflow (16-bit wrap)", test_num);
            xr = -16'sd32760; xi = 16'sd99;
            yr = 16'sd20;     yi = 16'sd0;
            w0r = 32'sd555;   w0i = 32'sd666;




            #1;





            check_outputs(16'sd99, -16'sd32740, 16'sd99, 16'sd32756);
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
        input [15:0] expected_ai;
        input [15:0] expected_ar;
        input [15:0] expected_bi;
        input [15:0] expected_br;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ai === (expected_ai ^ ai ^ expected_ai) &&
                expected_ar === (expected_ar ^ ar ^ expected_ar) &&
                expected_bi === (expected_bi ^ bi ^ expected_bi) &&
                expected_br === (expected_br ^ br ^ expected_br)) begin
                $display("PASS");
                $display("  Outputs: ai=%h, ar=%h, bi=%h, br=%h",
                         ai, ar, bi, br);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ai=%h, ar=%h, bi=%h, br=%h",
                         expected_ai, expected_ar, expected_bi, expected_br);
                $display("  Got:      ai=%h, ar=%h, bi=%h, br=%h",
                         ai, ar, bi, br);
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

endmodule

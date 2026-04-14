`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [15:0] x0;
    reg [15:0] x1;
    wire [15:0] y0;
    wire [15:0] y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .x0(x0),
        .x1(x1),
        .y0(y0),
        .y1(y1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Direct Mode (ctrl=0)", test_num);
            ctrl = 1'b0;
            x0 = 16'hAAAA;
            x1 = 16'h5555;
            #1;

            check_outputs(16'hAAAA, 16'h5555);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Cross Mode (ctrl=1)", test_num);
            ctrl = 1'b1;
            x0 = 16'hAAAA;
            x1 = 16'h5555;
            #1;

            check_outputs(16'h5555, 16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Direct Mode with Different Values", test_num);
            ctrl = 1'b0;
            x0 = 16'h1234;
            x1 = 16'hFEDC;
            #1;

            check_outputs(16'h1234, 16'hFEDC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Cross Mode with Different Values", test_num);
            ctrl = 1'b1;
            x0 = 16'h1234;
            x1 = 16'hFEDC;
            #1;

            check_outputs(16'hFEDC, 16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros and All Ones (Direct)", test_num);
            ctrl = 1'b0;
            x0 = 16'h0000;
            x1 = 16'hFFFF;
            #1;

            check_outputs(16'h0000, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros and All Ones (Cross)", test_num);
            ctrl = 1'b1;
            x0 = 16'h0000;
            x1 = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern (Direct)", test_num);
            ctrl = 1'b0;
            x0 = 16'hF0F0;
            x1 = 16'h0F0F;
            #1;

            check_outputs(16'hF0F0, 16'h0F0F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Same inputs on both lines (Direct)", test_num);
            ctrl = 1'b0;
            x0 = 16'hBEEF;
            x1 = 16'hBEEF;
            #1;

            check_outputs(16'hBEEF, 16'hBEEF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Same inputs on both lines (Cross)", test_num);
            ctrl = 1'b1;
            x0 = 16'hDEAD;
            x1 = 16'hDEAD;
            #1;

            check_outputs(16'hDEAD, 16'hDEAD);
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
        testcase009();
        
        
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
        input [15:0] expected_y0;
        input [15:0] expected_y1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1)) begin
                $display("PASS");
                $display("  Outputs: y0=%h, y1=%h",
                         y0, y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%h, y1=%h",
                         expected_y0, expected_y1);
                $display("  Got:      y0=%h, y1=%h",
                         y0, y1);
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

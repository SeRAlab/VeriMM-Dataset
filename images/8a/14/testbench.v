`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] mx;
    reg [10:0] my;
    reg [10:0] x;
    reg [10:0] y;
    wire [3:0] yes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mx(mx),
        .my(my),
        .x(x),
        .y(y),
        .yes(yes)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point exactly at (mx, my)", test_num);
            x = 11'd100; y = 11'd100; mx = 11'd100; my = 11'd100;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point in bottom-left relative to (mx, my)", test_num);
            x = 11'd50; y = 11'd50; mx = 11'd100; my = 11'd100;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point in top-right relative to (mx, my)", test_num);
            x = 11'd150; y = 11'd150; mx = 11'd100; my = 11'd100;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point in top-left relative to (mx, my)", test_num);
            x = 11'd50; y = 11'd150; mx = 11'd100; my = 11'd100;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point in bottom-right relative to (mx, my)", test_num);
            x = 11'd150; y = 11'd50; mx = 11'd100; my = 11'd100;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check - Minimum possible values", test_num);
            x = 11'd0; y = 11'd0; mx = 11'd1; my = 11'd1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check - Maximum possible values", test_num);
            x = 11'd2047; y = 11'd2047; mx = 11'd1024; my = 11'd1024;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical alignment check", test_num);
            x = 11'd500; y = 11'd800; mx = 11'd500; my = 11'd500;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horizontal alignment check", test_num);
            x = 11'd800; y = 11'd500; mx = 11'd500; my = 11'd500;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large coordinate difference", test_num);
            x = 11'd2000; y = 11'd10; mx = 11'd20; my = 11'd1900;
            #1;

            check_outputs(4'b0110);
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
        testcase010();
        
        
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
        input [3:0] expected_yes;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_yes === (expected_yes ^ yes ^ expected_yes)) begin
                $display("PASS");
                $display("  Outputs: yes=%h",
                         yes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: yes=%h",
                         expected_yes);
                $display("  Got:      yes=%h",
                         yes);
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

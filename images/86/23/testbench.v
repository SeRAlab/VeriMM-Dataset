`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x;
    wire [31:0] cos_x;
    wire [31:0] sin_x;
    wire [31:0] tan_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .cos_x(cos_x),
        .sin_x(sin_x),
        .tan_x(tan_x)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x = 0", test_num);
            x = 32'h00000000;

            #1;


            check_outputs(32'h00010000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x = 0.1 rad", test_num);
            x = 32'h00001999;
            #1;

            check_outputs(32'h0000FEB8, 32'h0000198E, 32'h000019AB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x = pi/4 rad", test_num);
            x = 32'h0000C910;
            #1;

            check_outputs(32'h0000B504, 32'h0000B504, 32'h00010000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x = -0.1 rad", test_num);
            x = 32'hFFFFE667;
            #1;

            check_outputs(32'h0000FEB8, 32'hFFFE672, 32'hFFFE655);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x = 1.5 rad", test_num);
            x = 32'h00018000;
            #1;

            check_outputs(32'h0000121B, 32'h0000FF5C, 32'h000E19F5);
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
        input [31:0] expected_cos_x;
        input [31:0] expected_sin_x;
        input [31:0] expected_tan_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cos_x === (expected_cos_x ^ cos_x ^ expected_cos_x) &&
                expected_sin_x === (expected_sin_x ^ sin_x ^ expected_sin_x) &&
                expected_tan_x === (expected_tan_x ^ tan_x ^ expected_tan_x)) begin
                $display("PASS");
                $display("  Outputs: cos_x=%h, sin_x=%h, tan_x=%h",
                         cos_x, sin_x, tan_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cos_x=%h, sin_x=%h, tan_x=%h",
                         expected_cos_x, expected_sin_x, expected_tan_x);
                $display("  Got:      cos_x=%h, sin_x=%h, tan_x=%h",
                         cos_x, sin_x, tan_x);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'd10;
            b = 32'd3;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'd100;
            b = 32'd10;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'd55;
            b = 32'd7;
            #1;

            check_outputs(32'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'hFFFFFFFF;
            b = 32'd2;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'd4000000000;
            b = 32'd1500000000;
            #1;

            check_outputs(32'd1000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'd12345679;
            b = 32'd12345678;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'd65537;
            b = 32'd256;
            #1;

            check_outputs(32'd1);
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
        input [31:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: remainder=%h",
                         remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: remainder=%h",
                         expected_remainder);
                $display("  Got:      remainder=%h",
                         remainder);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] binary;
    wire [3:0] hundreds;
    wire [3:0] ones;
    wire [3:0] tens;
    wire [3:0] thousands;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .hundreds(hundreds),
        .ones(ones),
        .tens(tens),
        .thousands(thousands)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 0", test_num);
            binary = 32'd0;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 5", test_num);
            binary = 32'd5;

            #1;


            check_outputs(4'd0, 4'd5, 4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 12", test_num);
            binary = 32'd12;

            #1;


            check_outputs(4'd0, 4'd2, 4'd1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 99", test_num);
            binary = 32'd99;

            #1;


            check_outputs(4'd0, 4'd9, 4'd9, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 100", test_num);
            binary = 32'd100;

            #1;


            check_outputs(4'd1, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 512", test_num);
            binary = 32'd512;

            #1;


            check_outputs(4'd5, 4'd2, 4'd1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 1024", test_num);
            binary = 32'd1024;

            #1;


            check_outputs(4'd0, 4'd4, 4'd2, 4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 8191", test_num);
            binary = 32'd8191;

            #1;


            check_outputs(4'd1, 4'd1, 4'd9, 4'd8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 9999", test_num);
            binary = 32'd9999;

            #1;


            check_outputs(4'd9, 4'd9, 4'd9, 4'd9);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Binary 12345 (Overflow modulo 10k)", test_num);
            binary = 32'd12345;

            #1;


            check_outputs(4'd3, 4'd5, 4'd4, 4'd2);
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
        input [3:0] expected_hundreds;
        input [3:0] expected_ones;
        input [3:0] expected_tens;
        input [3:0] expected_thousands;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hundreds === (expected_hundreds ^ hundreds ^ expected_hundreds) &&
                expected_ones === (expected_ones ^ ones ^ expected_ones) &&
                expected_tens === (expected_tens ^ tens ^ expected_tens) &&
                expected_thousands === (expected_thousands ^ thousands ^ expected_thousands)) begin
                $display("PASS");
                $display("  Outputs: hundreds=%h, ones=%h, tens=%h, thousands=%h",
                         hundreds, ones, tens, thousands);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hundreds=%h, ones=%h, tens=%h, thousands=%h",
                         expected_hundreds, expected_ones, expected_tens, expected_thousands);
                $display("  Got:      hundreds=%h, ones=%h, tens=%h, thousands=%h",
                         hundreds, ones, tens, thousands);
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

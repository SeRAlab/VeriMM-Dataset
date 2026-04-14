`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .r(r)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division by Zero (b=0)", test_num);
            a = 32'd100;
            b = 32'd0;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dividend is Zero (a=0)", test_num);
            a = 32'd0;
            b = 32'd50;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Modulo (17 % 5)", test_num);
            a = 32'd17;
            b = 32'd5;
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dividend < Divisor (5 % 10)", test_num);
            a = 32'd5;
            b = 32'd10;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dividend == Divisor (15 % 15)", test_num);
            a = 32'd15;
            b = 32'd15;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Perfect Division (100 % 10)", test_num);
            a = 32'd100;
            b = 32'd10;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Numbers (0xFFFFFFFF % 0x7FFFFFFF)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h7FFFFFFF;


            #1;



            check_outputs(32'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Divisor is 1", test_num);
            a = 32'hABCDEF12;
            b = 32'd1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Dividend, Power of 2 Divisor", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00010000;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime Number Modulo (101 % 7)", test_num);
            a = 32'd101;
            b = 32'd7;
            #1;

            check_outputs(32'd3);
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
        input [31:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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

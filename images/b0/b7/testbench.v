`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CarryIn;
    reg [27:0] x;
    reg [27:0] y;
    wire [28:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CarryIn(CarryIn),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 28'h0;
            y = 28'h0;
            CarryIn = 0;
            #1;

            check_outputs(29'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 28'h0;
            y = 28'h0;
            CarryIn = 1;
            #1;

            check_outputs(29'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 28'hFFFFFFF;
            y = 28'h0;
            CarryIn = 0;
            #1;

            check_outputs(29'h0FFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 28'hFFFFFFF;
            y = 28'h0;
            CarryIn = 1;
            #1;

            check_outputs(29'h10000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 28'h5555555;
            y = 28'hAAAAAAA;
            CarryIn = 0;
            #1;

            check_outputs(29'h0FFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 28'h5555555;
            y = 28'hAAAAAAA;
            CarryIn = 1;
            #1;

            check_outputs(29'h10000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 28'hFFFFFFF;
            y = 28'hFFFFFFF;
            CarryIn = 1;

            #1;


            check_outputs(29'h1FFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 28'hFFFFFFF;
            y = 28'hFFFFFFF;
            CarryIn = 0;

            #1;


            check_outputs(29'h1FFFFFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            x = 28'h1234567;
            y = 28'h89ABCDE;
            CarryIn = 0;

            #1;


            check_outputs(29'h09BEF245);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            x = 28'h8000000;
            y = 28'h8000000;
            CarryIn = 0;

            #1;


            check_outputs(29'h10000000);
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
        input [28:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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

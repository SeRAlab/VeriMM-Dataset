`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'h0000; b = 16'h0000;
            $display("Test %0d: All Zeros (a=%h, b=%h)", test_num, a, b);
            #1;

            check_outputs(16'hCD00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 16'h1005; b = 16'h2005;
            $display("Test %0d: Basic Addition (a=%h, b=%h)", test_num, a, b);
            #1;

            check_outputs(16'hC730);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'h00FF; b = 16'h0002;
            $display("Test %0d: Low Byte Overflow (a=%h, b=%h)", test_num, a, b);
            #1;

            check_outputs(16'hCC00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'hFF00; b = 16'h0100;
            $display("Test %0d: High Byte Overflow (a=%h, b=%h)", test_num, a, b);
            #1;

            check_outputs(16'hCD00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 16'hFFFF; b = 16'hFFFF;
            $display("Test %0d: Max Values (a=%h, b=%h)", test_num, a, b);
            #1;

            check_outputs(16'h33FE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 16'h12CD; b = 16'h0000;
            $display("Test %0d: XOR Cancellation (a=%h, b=%h)", test_num, a, b);
            #1;

            check_outputs(16'h0012);
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
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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

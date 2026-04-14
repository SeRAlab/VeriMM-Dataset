`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in1;
    reg [3:0] in2;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Sum <= 9 (2 + 3)", test_num);
        in1 = 4'd2;
        in2 = 4'd3;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Boundary Sum = 9 (4 + 5)", test_num);
        in1 = 4'd4;
        in2 = 4'd5;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Boundary Sum = 10 (5 + 5 -> 10 - 6 = 4)", test_num);
        in1 = 4'd5;
        in2 = 4'd5;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Large Sum within 4-bit (7 + 8 -> 15 - 6 = 9)", test_num);
        in1 = 4'd7;
        in2 = 4'd8;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Sum exceeding 15 (8 + 8 -> 16 - 6 = 10)", test_num);
        in1 = 4'd8;
        in2 = 4'd8;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Minimum sum (0 + 0)", test_num);
        in1 = 4'd0;
        in2 = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Maximum sum (15 + 15 -> 30 - 6 = 24 -> 4-bit wrap = 8)", test_num);
        in1 = 4'd15;
        in2 = 4'd15;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: One input max, sum > 9 (15 + 0 -> 15 - 6 = 9)", test_num);
        in1 = 4'd15;
        in2 = 4'd0;
        #1;

        check_outputs(4'd9);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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

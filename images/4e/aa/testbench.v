`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire bout;
    wire [3:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .bout(bout),
        .diff(diff)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 4'd10;
        b = 4'd3;
        $display("Test Case %0d: Subtracting %d from %d", test_num, b, a);

        #1;


        check_outputs(1'b0, 4'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 4'd5;
        b = 4'd5;
        $display("Test Case %0d: Subtracting %d from %d (Result Zero)", test_num, b, a);

        #1;


        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 4'd2;
        b = 4'd5;
        $display("Test Case %0d: Small minus Large (Borrow Case)", test_num, b, a);

        #1;


        check_outputs(1'b1, 4'd13);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 4'd0;
        b = 4'd1;
        $display("Test Case %0d: 0 - 1 (Maximum Borrow)", test_num, b, a);

        #1;


        check_outputs(1'b1, 4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 4'd15;
        b = 4'd0;
        $display("Test Case %0d: Max minus Min", test_num, b, a);

        #1;


        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 4'd15;
        b = 4'd15;
        $display("Test Case %0d: Max minus Max", test_num, b, a);

        #1;


        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 4'd0;
        b = 4'd15;
        $display("Test Case %0d: Min minus Max", test_num, b, a);

        #1;


        check_outputs(1'b1, 4'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 4'd8;
        b = 4'd4;
        $display("Test Case %0d: Simple Subtraction", test_num, b, a);

        #1;


        check_outputs(1'b0, 4'd4);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        a = 4'b1010;
        b = 4'b1100;
        $display("Test Case %0d: Binary values 1010 - 1100", test_num);

        #1;


        check_outputs(1'b1, 4'b1110);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        a = 4'b0111;
        b = 4'b0011;
        $display("Test Case %0d: Binary values 0111 - 0011", test_num);

        #1;


        check_outputs(1'b0, 4'b0100);
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
        input expected_bout;
        input [3:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bout === (expected_bout ^ bout ^ expected_bout) &&
                expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: bout=%b, diff=%h",
                         bout, diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bout=%b, diff=%h",
                         expected_bout, expected_diff);
                $display("  Got:      bout=%b, diff=%h",
                         bout, diff);
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

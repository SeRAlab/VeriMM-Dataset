`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] a;
    reg [19:0] b;
    reg [19:0] c;
    reg [15:0] d;
    reg [15:0] e;
    reg [15:0] f;
    wire [41:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            a = 20'd0; b = 20'd0; c = 20'd0; d = 16'd0; e = 16'd0; f = 16'd0;
            #1;

            check_outputs(42'd0);
        end
        endtask

    task testcase002;

        reg [41:0] exp;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Maximum Values", test_num);
            a = 20'hFFFFF;
            b = 20'hFFFFF;
            c = 20'hFFFFF;
            d = 16'hFFFF;
            e = 16'hFFFF;
            f = 16'hFFFF;

            exp = (42'hFFFFF * 42'hFFFFF) + (42'hFFFFF * 42'hFFFF) + (42'hFFFF * 42'hFFFF);
            #1;

            check_outputs(exp);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only a * b", test_num);
            a = 20'd1048575;
            b = 20'd2;
            c = 20'd0; d = 16'd0; e = 16'd0; f = 16'd0;
            #1;

            check_outputs(42'd2097150);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only c * d", test_num);
            a = 20'd0; b = 20'd0;
            c = 20'd1000;
            d = 16'd500;
            e = 16'd0; f = 16'd0;
            #1;

            check_outputs(42'd500000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only e * f", test_num);
            a = 20'd0; b = 20'd0; c = 20'd0; d = 16'd0;
            e = 16'hAAAA;
            f = 16'h5555;
            #1;

            check_outputs(42'h38E31C72);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplicative Identity", test_num);
            a = 20'd12345;
            b = 20'd1;
            c = 20'd67890;
            d = 16'd1;
            e = 16'd555;
            f = 16'd1;
            #1;

            check_outputs(42'd12345 + 42'd67890 + 42'd555);
        end
        endtask

    task testcase007;

        reg [41:0] exp;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Mixed Values", test_num);
            a = 20'h12345;
            b = 20'h6789A;
            c = 20'hABCDE;
            d = 16'hF0F0;
            e = 16'h1357;
            f = 16'h2468;
            exp = (42'h12345 * 42'h6789A) + (42'hABCDE * 42'hF0F0) + (42'h1357 * 42'h2468);
            #1;

            check_outputs(exp);
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
        input [41:0] expected_y;
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

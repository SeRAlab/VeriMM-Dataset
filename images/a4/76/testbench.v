`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg ce;
    reg clk;
    reg clr;
    wire op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .op(op)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Positive a < b (10 < 20)", test_num);

        clk = 0; clr = 1; ce = 0; a = 0; b = 0;
        #10;
        clr = 0; ce = 1;

        a = 32'd10;
        b = 32'd20;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Positive a > b (50 < 30)", test_num);
        clk = 0; clr = 1; ce = 0;
        #10;
        clr = 0; ce = 1;
        a = 32'd50;
        b = 32'd30;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Signed Negative Comparison (-20 < -10)", test_num);
        clk = 0; clr = 1; ce = 0;
        #10;
        clr = 0; ce = 1;
        a = -32'd20;
        b = -32'd10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Signed Negative Comparison (-5 < -15)", test_num);
        clk = 0; clr = 1; ce = 0;
        #10;
        clr = 0; ce = 1;
        a = -32'd5;
        b = -32'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Negative vs Positive (-1 < 1)", test_num);
        clk = 0; clr = 1; ce = 0;
        #10;
        clr = 0; ce = 1;
        a = -32'd1;
        b = 32'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Positive vs Negative (1 < -1)", test_num);
        clk = 0; clr = 1; ce = 0;
        #10;
        clr = 0; ce = 1;
        a = 32'd1;
        b = -32'd1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Equality test (100 < 100)", test_num);
        clk = 0; clr = 1; ce = 0;
        #10;
        clr = 0; ce = 1;
        a = 32'd100;
        b = 32'd100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Boundary - INT_MIN vs INT_MAX", test_num);
        clk = 0; clr = 1; ce = 0;
        #10;
        clr = 0; ce = 1;
        a = 32'h8000_0000;
        b = 32'h7FFF_FFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Boundary - INT_MAX vs INT_MIN", test_num);
        clk = 0; clr = 1; ce = 0;
        #10;
        clr = 0; ce = 1;
        a = 32'h7FFF_FFFF;
        b = 32'h8000_0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Zero comparison (0 < 0)", test_num);
        clk = 0; clr = 1; ce = 0;
        #10;
        clr = 0; ce = 1;
        a = 32'd0;
        b = 32'd0;
        #1;

        check_outputs(1'b0);
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
        input expected_op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%b",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%b",
                         expected_op);
                $display("  Got:      op=%b",
                         op);
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

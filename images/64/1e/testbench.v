`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
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
        test_num = test_num + 1;
        $display("Test %0d: Both inputs zero (Equal)", test_num);
        clr = 1; ce = 0; clk = 0;
        a = 8'h00;
        b = 8'h00;
        #10 clr = 0; ce = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Both inputs maximum (Equal)", test_num);
        clr = 1; ce = 1;
        a = 8'hFF;
        b = 8'hFF;
        #10 clr = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inequality (a > b)", test_num);
        clr = 1;
        a = 8'h01;
        b = 8'h00;
        #10 clr = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inequality (a < b)", test_num);
        clr = 1;
        a = 8'h00;
        b = 8'h01;
        #10 clr = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-range value (Equal)", test_num);
        clr = 1;
        a = 8'h80;
        b = 8'h80;
        #10 clr = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits (Not Equal)", test_num);
        clr = 1;
        a = 8'b10101010;
        b = 8'b01010101;
        #10 clr = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit difference (Not Equal)", test_num);
        clr = 1;
        a = 8'hFE;
        b = 8'hFF;
        #10 clr = 0;
        #10;
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

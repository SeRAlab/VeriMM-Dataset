`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] arg_0;
    reg [15:0] arg_1;
    reg arg_2;
    reg clk;
    reg rst;
    wire [15:0] ret_0;
    wire [15:0] ret_1;
    wire ret_2;
    wire ret_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arg_0(arg_0),
        .arg_1(arg_1),
        .arg_2(arg_2),
        .clk(clk),
        .rst(rst),
        .ret_0(ret_0),
        .ret_1(ret_1),
        .ret_2(ret_2),
        .ret_3(ret_3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        rst = 1;
        #20 rst = 0;
        arg_0 = 16'h3C00;
        arg_1 = 16'h3C00;
        arg_2 = 1'b0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h4000, 16'h0000, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        rst = 1;
        #20 rst = 0;
        arg_0 = 16'h4000;
        arg_1 = 16'h3C00;
        arg_2 = 1'b1;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h3C00, 16'h0000, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        rst = 1;
        #20 rst = 0;
        arg_0 = 16'h3C00;
        arg_1 = 16'h3C00;
        arg_2 = 1'b1;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h0000, 16'h0000, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        rst = 1;
        #20 rst = 0;
        arg_0 = 16'h4000;
        arg_1 = 16'h3C00;
        arg_2 = 1'b0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h4200, 16'h0000, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        rst = 1;
        #20 rst = 0;
        arg_0 = 16'h3800;
        arg_1 = 16'h3800;
        arg_2 = 1'b0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h3C00, 16'h0000, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        rst = 1;
        #20 rst = 0;
        arg_0 = 16'hBC00;
        arg_1 = 16'hBC00;
        arg_2 = 1'b0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'hC000, 16'h0000, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        rst = 1;
        #20 rst = 0;
        arg_0 = 16'h0000;
        arg_1 = 16'h0000;
        arg_2 = 1'b0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h0000, 16'h0000, 1'b0, 1'b0);
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
        input [15:0] expected_ret_0;
        input [15:0] expected_ret_1;
        input expected_ret_2;
        input expected_ret_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ret_0 === (expected_ret_0 ^ ret_0 ^ expected_ret_0) &&
                expected_ret_1 === (expected_ret_1 ^ ret_1 ^ expected_ret_1) &&
                expected_ret_2 === (expected_ret_2 ^ ret_2 ^ expected_ret_2) &&
                expected_ret_3 === (expected_ret_3 ^ ret_3 ^ expected_ret_3)) begin
                $display("PASS");
                $display("  Outputs: ret_0=%h, ret_1=%h, ret_2=%b, ret_3=%b",
                         ret_0, ret_1, ret_2, ret_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ret_0=%h, ret_1=%h, ret_2=%b, ret_3=%b",
                         expected_ret_0, expected_ret_1, expected_ret_2, expected_ret_3);
                $display("  Got:      ret_0=%h, ret_1=%h, ret_2=%b, ret_3=%b",
                         ret_0, ret_1, ret_2, ret_3);
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

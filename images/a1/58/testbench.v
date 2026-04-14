`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] arg_0;
    reg [15:0] arg_1;
    reg clk;
    reg rst;
    wire ret_0;
    wire [4:0] ret_1;
    wire [4:0] ret_2;
    wire [11:0] ret_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arg_0(arg_0),
        .arg_1(arg_1),
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
            $display("Test Case %0d: 1.0 * 1.0", test_num);
            rst = 1; arg_0 = 0; arg_1 = 0;
            @(posedge clk);
            #1 rst = 0;
            arg_0 = 16'h3C00;
            arg_1 = 16'h3C00;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 5'h0F, 5'h0F, 12'h800);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -1.0 * 1.0 with different exponents", test_num);
            rst = 1; arg_0 = 0; arg_1 = 0;
            @(posedge clk);
            #1 rst = 0;
            arg_0 = 16'hA800;
            arg_1 = 16'h5000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 5'h0A, 5'h14, 12'h800);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -1.5 * -1.5", test_num);
            rst = 1; arg_0 = 0; arg_1 = 0;
            @(posedge clk);
            #1 rst = 0;
            arg_0 = 16'hBE00;
            arg_1 = 16'hBE00;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 5'h0F, 5'h0F, 12'h900);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Mantissas", test_num);
            rst = 1; arg_0 = 0; arg_1 = 0;
            @(posedge clk);
            #1 rst = 0;
            arg_0 = 16'h07FF;
            arg_1 = 16'h07FF;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 5'h01, 5'h01, 12'hFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1.25 * -1.25", test_num);
            rst = 1; arg_0 = 0; arg_1 = 0;
            @(posedge clk);
            #1 rst = 0;
            arg_0 = 16'h1500;
            arg_1 = 16'h8900;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 5'h05, 5'h02, 12'hC80);
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
        input expected_ret_0;
        input [4:0] expected_ret_1;
        input [4:0] expected_ret_2;
        input [11:0] expected_ret_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ret_0 === (expected_ret_0 ^ ret_0 ^ expected_ret_0) &&
                expected_ret_1 === (expected_ret_1 ^ ret_1 ^ expected_ret_1) &&
                expected_ret_2 === (expected_ret_2 ^ ret_2 ^ expected_ret_2) &&
                expected_ret_3 === (expected_ret_3 ^ ret_3 ^ expected_ret_3)) begin
                $display("PASS");
                $display("  Outputs: ret_0=%b, ret_1=%h, ret_2=%h, ret_3=%h",
                         ret_0, ret_1, ret_2, ret_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ret_0=%b, ret_1=%h, ret_2=%h, ret_3=%h",
                         expected_ret_0, expected_ret_1, expected_ret_2, expected_ret_3);
                $display("  Got:      ret_0=%b, ret_1=%h, ret_2=%h, ret_3=%h",
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

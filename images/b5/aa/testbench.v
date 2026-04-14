`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [21:0] arg_0;
    reg arg_1;
    reg arg_2;
    reg [4:0] arg_3;
    reg arg_4;
    reg arg_5;
    reg clk;
    reg rst;
    wire [20:0] ret_0;
    wire ret_1;
    wire ret_2;
    wire [4:0] ret_3;
    wire ret_4;
    wire ret_5;
    wire ret_6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arg_0(arg_0),
        .arg_1(arg_1),
        .arg_2(arg_2),
        .arg_3(arg_3),
        .arg_4(arg_4),
        .arg_5(arg_5),
        .clk(clk),
        .rst(rst),
        .ret_0(ret_0),
        .ret_1(ret_1),
        .ret_2(ret_2),
        .ret_3(ret_3),
        .ret_4(ret_4),
        .ret_5(ret_5),
        .ret_6(ret_6)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset and Zero Inputs", test_num);
        rst = 1;
        arg_0 = 22'h0; arg_1 = 1'b0; arg_2 = 1'b0; arg_3 = 5'h0; arg_4 = 1'b0; arg_5 = 1'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);


        #1;



        check_outputs(21'h0, 1'b0, 1'b0, 5'h0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Input Values", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        arg_0 = 22'h3FFFFF; arg_1 = 1'b1; arg_2 = 1'b1; arg_3 = 5'h1F; arg_4 = 1'b1; arg_5 = 1'b1;
        @(posedge clk);

        #1;


        check_outputs(21'h1FFFFF, 1'b1, 1'b1, 5'h1F, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bit Pattern A", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        arg_0 = 22'h2AAAAA; arg_1 = 1'b1; arg_2 = 1'b0; arg_3 = 5'h0A; arg_4 = 1'b1; arg_5 = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(21'h155555, 1'b1, 1'b0, 5'h0A, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bit Pattern B", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        arg_0 = 22'h155555; arg_1 = 1'b0; arg_2 = 1'b1; arg_3 = 5'h15; arg_4 = 1'b0; arg_5 = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(21'h0AAAAA, 1'b0, 1'b1, 5'h15, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Control Flags and Mixed Data", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        arg_0 = 22'h0F0F0F; arg_1 = 1'b1; arg_2 = 1'b1; arg_3 = 5'h10; arg_4 = 1'b0; arg_5 = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(21'h078787, 1'b1, 1'b1, 5'h10, 1'b0, 1'b0, 1'b0);
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
        input [20:0] expected_ret_0;
        input expected_ret_1;
        input expected_ret_2;
        input [4:0] expected_ret_3;
        input expected_ret_4;
        input expected_ret_5;
        input expected_ret_6;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ret_0 === (expected_ret_0 ^ ret_0 ^ expected_ret_0) &&
                expected_ret_1 === (expected_ret_1 ^ ret_1 ^ expected_ret_1) &&
                expected_ret_2 === (expected_ret_2 ^ ret_2 ^ expected_ret_2) &&
                expected_ret_3 === (expected_ret_3 ^ ret_3 ^ expected_ret_3) &&
                expected_ret_4 === (expected_ret_4 ^ ret_4 ^ expected_ret_4) &&
                expected_ret_5 === (expected_ret_5 ^ ret_5 ^ expected_ret_5) &&
                expected_ret_6 === (expected_ret_6 ^ ret_6 ^ expected_ret_6)) begin
                $display("PASS");
                $display("  Outputs: ret_0=%h, ret_1=%b, ret_2=%b, ret_3=%h, ret_4=%b, ret_5=%b, ret_6=%b",
                         ret_0, ret_1, ret_2, ret_3, ret_4, ret_5, ret_6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ret_0=%h, ret_1=%b, ret_2=%b, ret_3=%h, ret_4=%b, ret_5=%b, ret_6=%b",
                         expected_ret_0, expected_ret_1, expected_ret_2, expected_ret_3, expected_ret_4, expected_ret_5, expected_ret_6);
                $display("  Got:      ret_0=%h, ret_1=%b, ret_2=%b, ret_3=%h, ret_4=%b, ret_5=%b, ret_6=%b",
                         ret_0, ret_1, ret_2, ret_3, ret_4, ret_5, ret_6);
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

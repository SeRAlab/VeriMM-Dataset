`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [14:0] arg_0;
    reg arg_1;
    reg arg_2;
    reg [7:0] arg_3;
    reg arg_4;
    reg arg_5;
    reg arg_6;
    reg clk;
    reg rst;
    wire [15:0] ret_0;

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
        .arg_6(arg_6),
        .clk(clk),
        .rst(rst),
        .ret_0(ret_0)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Reset and Zero Check", test_num);
        rst = 1;
        arg_0 = 0; arg_1 = 0; arg_2 = 0; arg_3 = 0; arg_4 = 0; arg_5 = 0; arg_6 = 0;
        #20 rst = 0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: 1.0 + 1.0 = 2.0", test_num);
        rst = 1;
        #20 rst = 0;
        @(posedge clk);

        arg_1 = 1'b0; arg_0 = 15'h3C00;

        arg_2 = 1'b0; arg_3 = 8'h78; arg_4 = 1'b0; arg_5 = 1'b0; arg_6 = 1'b0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: 2.0 + 2.0 = 4.0", test_num);
        rst = 1;
        #20 rst = 0;
        @(posedge clk);

        arg_1 = 1'b0; arg_0 = 15'h4000;

        arg_2 = 1'b0; arg_3 = 8'h80; arg_4 = 1'b0; arg_5 = 1'b0; arg_6 = 1'b0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h4400);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: 1.0 - 1.0 = 0.0", test_num);
        rst = 1;
        #20 rst = 0;
        @(posedge clk);

        arg_1 = 1'b0; arg_0 = 15'h3C00;

        arg_2 = 1'b1; arg_3 = 8'h78; arg_4 = 1'b0; arg_5 = 1'b0; arg_6 = 1'b0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: 0.5 + 0.5 = 1.0", test_num);
        rst = 1;
        #20 rst = 0;
        @(posedge clk);

        arg_1 = 1'b0; arg_0 = 15'h3800;

        arg_2 = 1'b0; arg_3 = 8'h70; arg_4 = 1'b0; arg_5 = 1'b0; arg_6 = 1'b0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(16'h3C00);
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
        input [15:0] expected_ret_0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ret_0 === (expected_ret_0 ^ ret_0 ^ expected_ret_0)) begin
                $display("PASS");
                $display("  Outputs: ret_0=%h",
                         ret_0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ret_0=%h",
                         expected_ret_0);
                $display("  Got:      ret_0=%h",
                         ret_0);
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

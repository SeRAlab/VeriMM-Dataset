`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg arg_0;
    reg [4:0] arg_1;
    reg [4:0] arg_2;
    reg [11:0] arg_3;
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
        .clk(clk),
        .rst(rst),
        .ret_0(ret_0)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            rst = 1; #20; rst = 0;
            arg_0 = 0; arg_1 = 5'd15; arg_2 = 5'd15; arg_3 = 12'h400;
            @(posedge clk);
            #2;
            $display("Test %0d: Basic 1.0 * 1.0", test_num);
            #1;

            check_outputs(16'h3C00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            rst = 1; #20; rst = 0;
            arg_0 = 0; arg_1 = 5'd15; arg_2 = 5'd15; arg_3 = 12'h800;
            @(posedge clk);
            #2;
            $display("Test %0d: Normalization Shift (2.0 product)", test_num);
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            rst = 1; #20; rst = 0;
            arg_0 = 1; arg_1 = 5'd15; arg_2 = 5'd15; arg_3 = 12'h400;
            @(posedge clk);
            #2;
            $display("Test %0d: Negative Sign", test_num);
            #1;

            check_outputs(16'hBC00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            rst = 1; #20; rst = 0;
            arg_0 = 0; arg_1 = 5'd25; arg_2 = 5'd20; arg_3 = 12'h400;
            @(posedge clk);
            #2;
            $display("Test %0d: Max Finite Exponent (30)", test_num);
            #1;

            check_outputs(16'h7800);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            rst = 1; #20; rst = 0;
            arg_0 = 0; arg_1 = 5'd25; arg_2 = 5'd25; arg_3 = 12'h400;
            @(posedge clk);
            #2;
            $display("Test %0d: Overflow to Infinity", test_num);
            #1;

            check_outputs(16'h7C00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            rst = 1; #20; rst = 0;
            arg_0 = 0; arg_1 = 5'd5; arg_2 = 5'd5; arg_3 = 12'h400;
            @(posedge clk);
            #2;
            $display("Test %0d: Underflow to Zero", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            rst = 1; #20; rst = 0;
            arg_0 = 0; arg_1 = 5'd31; arg_2 = 5'd15; arg_3 = 12'h400;
            @(posedge clk);
            #2;
            $display("Test %0d: Infinity Input", test_num);
            #1;

            check_outputs(16'h7C00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            rst = 1; #20; rst = 0;
            arg_0 = 0; arg_1 = 5'd15; arg_2 = 5'd15; arg_3 = 12'h900;
            @(posedge clk);
            #2;
            $display("Test %0d: 1.5 * 1.5 = 2.25 (Shift + Frac)", test_num);

            #1;


            check_outputs(16'h4080);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            rst = 1; #20; rst = 0;
            arg_0 = 0; arg_1 = 5'd10; arg_2 = 5'd6; arg_3 = 12'h400;
            @(posedge clk);
            #2;
            $display("Test %0d: Smallest Normalized Exp (1)", test_num);
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            rst = 1; #20; rst = 0;
            arg_0 = 0; arg_1 = 5'd15; arg_2 = 5'd15; arg_3 = 12'h7FF;
            @(posedge clk);
            #2;
            $display("Test %0d: Max Mantissa No Shift", test_num);
            #1;

            check_outputs(16'h3FFF);
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

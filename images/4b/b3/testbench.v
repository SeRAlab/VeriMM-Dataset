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
        rst = 1; arg_0 = 0; arg_1 = 0; @(posedge clk);
        rst = 0; arg_0 = 16'h3C00; arg_1 = 16'h3C00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 5'h0F, 5'h0F, 12'h400);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        rst = 1; @(posedge clk);
        rst = 0; arg_0 = 16'hBC00; arg_1 = 16'h3C00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 5'h0F, 5'h0F, 12'h400);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        rst = 1; @(posedge clk);
        rst = 0; arg_0 = 16'hBC00; arg_1 = 16'hBC00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 5'h0F, 5'h0F, 12'h400);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        rst = 1; @(posedge clk);
        rst = 0; arg_0 = 16'h3FFF; arg_1 = 16'h3FFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 5'h0F, 5'h0F, 12'hFFC);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        rst = 1; @(posedge clk);
        rst = 0; arg_0 = 16'h0000; arg_1 = 16'h3C00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 5'h00, 5'h0F, 12'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        rst = 1; @(posedge clk);
        rst = 0; arg_0 = 16'h0001; arg_1 = 16'h3C00;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 5'h00, 5'h0F, 12'h001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        rst = 1; @(posedge clk);
        rst = 0; arg_0 = 16'h1500; arg_1 = 16'hE600;
        @(posedge clk);
        #1;



        #1;




        check_outputs(1'b1, 5'h05, 5'h19, 12'h780);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        rst = 1; @(posedge clk);
        rst = 0; arg_0 = 16'h61AA; arg_1 = 16'h2555;
        @(posedge clk);
        #1;



        #1;




        check_outputs(1'b0, 5'h18, 5'h09, 12'h78C);
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

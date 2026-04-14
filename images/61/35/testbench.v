`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK_IN;
    reg enb_1_2000_0;
    reg reset;
    reg [18:0] u;
    wire [18:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_IN(CLK_IN),
        .enb_1_2000_0(enb_1_2000_0),
        .reset(reset),
        .u(u),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Behavior", test_num);
        reset = 1;
        u = 19'sd500;
        enb_1_2000_0 = 1;
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(19'h00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive Input (100)", test_num);
        reset = 1; @(posedge CLK_IN);
        reset = 0; enb_1_2000_0 = 1; u = 19'sd100;
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(19'h0004B);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative Input (-100)", test_num);
        reset = 1; @(posedge CLK_IN);
        reset = 0; enb_1_2000_0 = 1; u = -19'sd100;
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(19'h7FFB5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Input", test_num);
        reset = 1; @(posedge CLK_IN);
        reset = 0; enb_1_2000_0 = 1; u = 19'sd0;
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(19'h00000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small Positive (1)", test_num);
        reset = 1; @(posedge CLK_IN);
        reset = 0; enb_1_2000_0 = 1; u = 19'sd1;
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(19'h00000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small Negative (-1)", test_num);
        reset = 1; @(posedge CLK_IN);
        reset = 0; enb_1_2000_0 = 1; u = -19'sd1;
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(19'h7FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Positive (262143)", test_num);
        reset = 1; @(posedge CLK_IN);
        reset = 0; enb_1_2000_0 = 1; u = 19'h3FFFF;
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(19'h2FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min Negative (-262144)", test_num);
        reset = 1; @(posedge CLK_IN);
        reset = 0; enb_1_2000_0 = 1; u = 19'h40000;
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(19'h50000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable Logic (Hold Value)", test_num);
        reset = 1; @(posedge CLK_IN);
        reset = 0; enb_1_2000_0 = 1; u = 19'sd100;
        @(posedge CLK_IN);
        #1;
        enb_1_2000_0 = 0; u = 19'sd400;
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(19'h0004B);
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
        input [18:0] expected_y;
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

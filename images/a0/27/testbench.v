`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg rst;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Addition (10 + 20)", test_num);
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;
        A = 32'd10;
        B = 32'd20;
        @(posedge clk);
        #1;

        check_outputs(32'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Addition with Zero (0 + 0)", test_num);
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;
        A = 32'd0;
        B = 32'd0;
        @(posedge clk);
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Overflow Handling (Max + 1)", test_num);
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        @(posedge clk);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Large Hex Addition", test_num);
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;
        A = 32'h12345678;
        B = 32'h11111111;
        @(posedge clk);
        #1;

        check_outputs(32'h23456789);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority (rst=1 while A, B non-zero)", test_num);
        @(negedge clk);
        rst = 1;
        A = 32'hABCDEF01;
        B = 32'h12345678;
        @(posedge clk);
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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

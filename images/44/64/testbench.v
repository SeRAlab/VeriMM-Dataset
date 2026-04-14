`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg add_sub;
    reg clk;
    reg [7:0] dataa;
    reg [7:0] datab;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_sub(add_sub),
        .clk(clk),
        .dataa(dataa),
        .datab(datab),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Addition (10 + 20)", test_num);
        dataa = 8'd10;
        datab = 8'd20;
        add_sub = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Subtraction (50 - 15)", test_num);
        dataa = 8'd50;
        datab = 8'd15;
        add_sub = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(8'd35);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Overflow (250 + 10)", test_num);
        dataa = 8'd250;
        datab = 8'd10;
        add_sub = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Underflow (5 - 10)", test_num);
        dataa = 8'd5;
        datab = 8'd10;
        add_sub = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(8'hFB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Values Addition (255 + 255)", test_num);
        dataa = 8'hFF;
        datab = 8'hFF;
        add_sub = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction to Zero (128 - 128)", test_num);
        dataa = 8'd128;
        datab = 8'd128;
        add_sub = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Addition (0 + 0)", test_num);
        dataa = 8'd0;
        datab = 8'd0;
        add_sub = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(8'd0);
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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

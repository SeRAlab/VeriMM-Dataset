`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    wire eq;
    wire gt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .eq(eq),
        .gt(gt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a <= 4'd0;
        b <= 4'd0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing Equality (0 == 0)", test_num);
        reset_dut();
        a <= 4'd0;
        b <= 4'd0;

        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing Equality (15 == 15)", test_num);
        reset_dut();
        a <= 4'd15;
        b <= 4'd15;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing Greater Than (10 > 5)", test_num);
        reset_dut();
        a <= 4'd10;
        b <= 4'd5;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing Greater Than (15 > 0)", test_num);
        reset_dut();
        a <= 4'd15;
        b <= 4'd0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing Less Than (3 < 7)", test_num);
        reset_dut();
        a <= 4'd3;
        b <= 4'd7;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing Less Than (0 < 1)", test_num);
        reset_dut();
        a <= 4'd0;
        b <= 4'd1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing Small Difference (8 > 7)", test_num);
        reset_dut();
        a <= 4'd8;
        b <= 4'd7;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1);
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
        input expected_eq;
        input expected_gt;
        begin
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, gt=%b",
                         eq, gt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, gt=%b",
                         expected_eq, expected_gt);
                $display("  Got:      eq=%b, gt=%b",
                         eq, gt);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, clk, eq, gt);
    end

endmodule

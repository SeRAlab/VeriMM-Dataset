`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg rst;
    wire y1;
    wire y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .y1(y1),
        .y2(y2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking Initial Reset State", test_num);
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking Toggling (1 cycle after reset)", test_num);
            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking Toggling (2 cycles after reset)", test_num);
            rst = 1;
            @(posedge clk);
            rst = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking Toggling (3 cycles after reset)", test_num);
            rst = 1;
            @(posedge clk);
            rst = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying Reset functionality during operation", test_num);
            rst = 1;
            @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Checking oscillation stability after 10 cycles", test_num);
            rst = 1;
            @(posedge clk);
            rst = 0;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_y1;
        input expected_y2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2)) begin
                $display("PASS");
                $display("  Outputs: y1=%b, y2=%b",
                         y1, y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y1=%b, y2=%b",
                         expected_y1, expected_y2);
                $display("  Got:      y1=%b, y2=%b",
                         y1, y2);
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

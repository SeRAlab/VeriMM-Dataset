`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    reg test_expr;
    reg xzcheck_enable;
    wire parity_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_n(reset_n),
        .test_expr(test_expr),
        .xzcheck_enable(xzcheck_enable),
        .parity_result(parity_result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            test_expr = 0;
            xzcheck_enable = 0;
            @(negedge clk);
            reset_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input '0' - Even Parity Check", test_num);
            reset_dut();
            test_expr = 1'b0;
            xzcheck_enable = 1'b1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input '1' - Odd Parity Check", test_num);
            reset_dut();
            test_expr = 1'b1;
            xzcheck_enable = 1'b1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Disabled Check", test_num);
            reset_dut();
            test_expr = 1'b1;
            xzcheck_enable = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Invalid Input 'X' Monitoring", test_num);
            reset_dut();
            test_expr = 1'bx;
            xzcheck_enable = 1'b1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Invalid Input 'Z' Monitoring", test_num);
            reset_dut();
            test_expr = 1'bz;
            xzcheck_enable = 1'b1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-Operation Reset", test_num);
            reset_dut();
            test_expr = 1'b1;
            xzcheck_enable = 1'b1;
            @(posedge clk);
            reset_n = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
            reset_n = 1;
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
        input expected_parity_result;
        begin
            if (expected_parity_result === (expected_parity_result ^ parity_result ^ expected_parity_result)) begin
                $display("PASS");
                $display("  Outputs: parity_result=%b",
                         parity_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity_result=%b",
                         expected_parity_result);
                $display("  Got:      parity_result=%b",
                         parity_result);
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
        $dumpvars(0,clk, reset_n, test_expr, xzcheck_enable, parity_result);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [9:0] x_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .x_out(x_out)
    );

        task reset_dut;

        begin
            rst = 1;
            sw_reg = 0;
            repeat(10) @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task wait_for_toggles;

        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1) begin
                @(x_out);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: sw=1, 4 toggles...", test_num);
            reset_dut();
            sw_reg = 4'd1;
            wait_for_toggles(4);
            #1;

            check_outputs(10'd252);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: sw=10, 2 toggles...", test_num);
            reset_dut();
            sw_reg = 4'd10;
            wait_for_toggles(2);
            #1;

            check_outputs(10'd236);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: sw=0, verify stability...", test_num);
            reset_dut();
            sw_reg = 4'd0;

            repeat(200) @(posedge clk);
            #1;

            check_outputs(10'd256);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: sw=15, 3 toggles...", test_num);
            reset_dut();
            sw_reg = 4'd15;
            wait_for_toggles(3);
            #1;

            check_outputs(10'd211);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: sw=2, 20 toggles...", test_num);
            reset_dut();
            sw_reg = 4'd2;
            wait_for_toggles(20);
            #1;

            check_outputs(10'd216);
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
        input [9:0] expected_x_out;
        begin
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h",
                         x_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h",
                         expected_x_out);
                $display("  Got:      x_out=%h",
                         x_out);
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
        $dumpvars(0,clk, x_out);
    end

endmodule

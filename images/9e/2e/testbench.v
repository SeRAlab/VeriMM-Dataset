`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] divider_factor;
    reg in_clk;
    wire out_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .divider_factor(divider_factor),
        .in_clk(in_clk),
        .out_clk(out_clk)
    );

    // Clock generation (10ns period)
    initial begin
        in_clk = 0;
        forever #5 in_clk = ~in_clk;
    end

        task reset_dut;

        begin
            divider_factor = 16'd0;
            repeat(2) @(posedge in_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Divider Factor 0 (Bypass)", test_num);
            reset_dut();
            divider_factor = 16'd0;
            repeat(5) @(posedge in_clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Divider Factor 1 (Divide by 2)", test_num);
            reset_dut();
            divider_factor = 16'd1;
            repeat(2) @(posedge in_clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Divider Factor 2 (Divide by 3)", test_num);
            reset_dut();
            divider_factor = 16'd2;
            repeat(3) @(posedge in_clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Divider Factor 3 (Divide by 4)", test_num);
            reset_dut();
            divider_factor = 16'd3;
            repeat(2) @(posedge in_clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Divider Factor 10 (Divide by 11)", test_num);
            reset_dut();
            divider_factor = 16'd10;
            repeat(11) @(posedge in_clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Divider Factor 100 (Divide by 101)", test_num);
            reset_dut();
            divider_factor = 16'd100;
            repeat(10) @(posedge in_clk);
            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_out_clk;
        begin
            if (expected_out_clk === (expected_out_clk ^ out_clk ^ expected_out_clk)) begin
                $display("PASS");
                $display("  Outputs: out_clk=%b",
                         out_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_clk=%b",
                         expected_out_clk);
                $display("  Got:      out_clk=%b",
                         out_clk);
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
        $dumpvars(0,divider_factor, in_clk, out_clk);
    end

endmodule

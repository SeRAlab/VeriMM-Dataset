`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg in_en;
    reg out_clk;
    reg rst;
    wire out_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_en(in_en),
        .out_clk(out_clk),
        .rst(rst),
        .out_en(out_en)
    );

    // Clock generation (10ns period)
    initial begin
        out_clk = 0;
        forever #5 out_clk = ~out_clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_en = 0;
            @(negedge out_clk);
            rst = 0;
            @(negedge out_clk);
        end
        endtask
    task testcase001;

        begin
            $display("testcase001: Reset Check");
            test_num = test_num + 1;
            reset_dut();
            repeat(2) @(negedge out_clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("testcase002: Normal Assertion Check");
            test_num = test_num + 1;
            reset_dut();
            in_en = 1;
            repeat(3) @(negedge out_clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("testcase003: Pulse Suppression Check (Short High)");
            test_num = test_num + 1;
            reset_dut();
            in_en = 1;
            @(negedge out_clk);
            in_en = 0;
            repeat(2) @(negedge out_clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("testcase004: Normal De-assertion Check");
            test_num = test_num + 1;
            reset_dut();

            in_en = 1;
            repeat(3) @(negedge out_clk);

            in_en = 0;
            repeat(3) @(negedge out_clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("testcase005: Glitch Suppression Check (Short Low)");
            test_num = test_num + 1;
            reset_dut();

            in_en = 1;
            repeat(3) @(negedge out_clk);

            in_en = 0;
            @(negedge out_clk);
            in_en = 1;
            repeat(2) @(negedge out_clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("testcase006: Rapid Toggling Check");
            test_num = test_num + 1;
            reset_dut();

            repeat(5) begin
                in_en = 1; @(negedge out_clk);
                in_en = 0; @(negedge out_clk);
            end
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("testcase007: Long Stability Check");
            test_num = test_num + 1;
            reset_dut();
            in_en = 1;
            repeat(10) @(negedge out_clk);
            in_en = 0;
            repeat(10) @(negedge out_clk);
            #1;

            check_outputs(1'b0);
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
        input expected_out_en;
        begin
            if (expected_out_en === (expected_out_en ^ out_en ^ expected_out_en)) begin
                $display("PASS");
                $display("  Outputs: out_en=%b",
                         out_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_en=%b",
                         expected_out_en);
                $display("  Got:      out_en=%b",
                         out_en);
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
        $dumpvars(0,in_en, out_clk, rst, out_en);
    end

endmodule

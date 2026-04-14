`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg water_in;
    reg water_out;
    wire water_in_end_sign;
    wire [2:0] water_level;
    wire water_out_end_sign;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .water_in(water_in),
        .water_out(water_out),
        .water_in_end_sign(water_in_end_sign),
        .water_level(water_level),
        .water_out_end_sign(water_out_end_sign)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            water_in = 0;
            water_out = 1;
            repeat(6) @(posedge clk);
            water_out = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Fill from empty to full...");
            reset_dut();
            water_in = 1;
            water_out = 0;
            repeat(4) @(posedge clk);
            water_in = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 3'd4, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Fill then drain to empty...");
            reset_dut();

            water_in = 1;
            repeat(4) @(posedge clk);

            water_in = 0;
            water_out = 1;
            repeat(4) @(posedge clk);
            water_out = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 3'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Overflow protection...");
            reset_dut();
            water_in = 1;
            repeat(6) @(posedge clk);
            water_in = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 3'd4, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Underflow protection...");
            reset_dut();
            water_out = 1;
            repeat(2) @(posedge clk);
            water_out = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 3'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Simultaneous flow...");
            reset_dut();

            water_in = 1;
            repeat(2) @(posedge clk);

            water_out = 1;
            repeat(3) @(posedge clk);
            water_in = 0;
            water_out = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 3'd2, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Partial fill...");
            reset_dut();
            water_in = 1;
            repeat(3) @(posedge clk);
            water_in = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 3'd3, 1'b0);
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
        input expected_water_in_end_sign;
        input [2:0] expected_water_level;
        input expected_water_out_end_sign;
        begin
            if (expected_water_in_end_sign === (expected_water_in_end_sign ^ water_in_end_sign ^ expected_water_in_end_sign) &&
                expected_water_level === (expected_water_level ^ water_level ^ expected_water_level) &&
                expected_water_out_end_sign === (expected_water_out_end_sign ^ water_out_end_sign ^ expected_water_out_end_sign)) begin
                $display("PASS");
                $display("  Outputs: water_in_end_sign=%b, water_level=%h, water_out_end_sign=%b",
                         water_in_end_sign, water_level, water_out_end_sign);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: water_in_end_sign=%b, water_level=%h, water_out_end_sign=%b",
                         expected_water_in_end_sign, expected_water_level, expected_water_out_end_sign);
                $display("  Got:      water_in_end_sign=%b, water_level=%h, water_out_end_sign=%b",
                         water_in_end_sign, water_level, water_out_end_sign);
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
        $dumpvars(0,clk, water_in, water_out, water_in_end_sign, water_level, water_out_end_sign);
    end

endmodule

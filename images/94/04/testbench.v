`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] clk_count_to;
    reg inclk;
    wire outclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_count_to(clk_count_to),
        .inclk(inclk),
        .outclk(outclk)
    );

    // Clock generation (10ns period)
    initial begin
        inclk = 0;
        forever #5 inclk = ~inclk;
    end

        task reset_dut;

        begin


            clk_count_to = 32'd0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Divisor = 2, checking first toggle after 2 cycles...");
            reset_dut();
            clk_count_to = 32'd2;
            repeat(2) @(posedge inclk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Divisor = 2, checking return to 0 after 2 more cycles...");
            reset_dut();
            clk_count_to = 32'd2;
            repeat(2) @(posedge inclk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Divisor = 5, checking toggle after 5 cycles...");
            reset_dut();
            clk_count_to = 32'd5;
            repeat(5) @(posedge inclk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Divisor = 5, checking return to 0 after 5 more cycles...");
            reset_dut();
            clk_count_to = 32'd5;
            repeat(5) @(posedge inclk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Divisor = 1, checking toggle every edge...");
            reset_dut();
            clk_count_to = 32'd1;
            repeat(1) @(posedge inclk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Divisor = 1, checking second toggle...");
            reset_dut();
            clk_count_to = 32'd1;
            repeat(1) @(posedge inclk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Divisor = 10, checking toggle after 10 cycles...");
            reset_dut();
            clk_count_to = 32'd10;
            repeat(10) @(posedge inclk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Divisor = 10, checking return to 0 after 10 more cycles...");
            reset_dut();
            clk_count_to = 32'd10;
            repeat(10) @(posedge inclk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Divisor = 100, checking toggle after 100 cycles...");
            reset_dut();
            clk_count_to = 32'd100;
            repeat(100) @(posedge inclk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Divisor = 100, checking return to 0 after 100 more cycles...");
            reset_dut();
            clk_count_to = 32'd100;
            repeat(100) @(posedge inclk);
            #1;
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_outclk;
        begin
            if (expected_outclk === (expected_outclk ^ outclk ^ expected_outclk)) begin
                $display("PASS");
                $display("  Outputs: outclk=%b",
                         outclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outclk=%b",
                         expected_outclk);
                $display("  Got:      outclk=%b",
                         outclk);
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
        $dumpvars(0,clk_count_to, inclk, outclk);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg hsync;
    reg vsync;
    wire b;
    wire g;
    wire r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hsync(hsync),
        .vsync(vsync),
        .b(b),
        .g(g),
        .r(r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            hsync = 0;
            vsync = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            hsync = 0;
            vsync = 0;
            repeat(5) @(posedge clk);
            #1;
            $display("Test Case 001: Both sync signals low (Blanking region)");
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            hsync = 1;
            vsync = 0;
            repeat(5) @(posedge clk);
            #1;
            $display("Test Case 002: Hsync high, Vsync low");
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            hsync = 0;
            vsync = 1;
            repeat(5) @(posedge clk);
            #1;
            $display("Test Case 003: Hsync low, Vsync high");
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            hsync = 1;
            vsync = 1;
            repeat(5) @(posedge clk);
            #1;
            $display("Test Case 004: Both sync signals high (Active display)");
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            hsync = 1;
            vsync = 1;
            @(posedge clk);
            hsync = 0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test Case 005: Transition to blanking (Hsync drops)");
            #1;

            check_outputs(0, 0, 0);
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
        input expected_b;
        input expected_g;
        input expected_r;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: b=%b, g=%b, r=%b",
                         b, g, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%b, g=%b, r=%b",
                         expected_b, expected_g, expected_r);
                $display("  Got:      b=%b, g=%b, r=%b",
                         b, g, r);
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
        $dumpvars(0,clk, hsync, vsync, b, g, r);
    end

endmodule

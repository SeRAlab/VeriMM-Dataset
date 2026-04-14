`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [15:0] i;
    reg rst_i;
    reg [3:0] volume;
    wire [15:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .i(i),
        .rst_i(rst_i),
        .volume(volume),
        .o(o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            i = 0;
            volume = 0;
            @(posedge clk_i);
            #1;
            rst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Mute (Volume 0)");
            reset_dut();
            i = 16'hABCD;
            volume = 4'b0000;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Scaling 1x (Volume 4'b0001)");
            reset_dut();
            i = 16'h1234;
            volume = 4'b0001;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Scaling 2x (Volume 4'b0010)");
            reset_dut();
            i = 16'h0005;
            volume = 4'b0010;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Scaling 4x (Volume 4'b0100)");
            reset_dut();
            i = 16'h0005;
            volume = 4'b0100;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h0014);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Scaling 8x (Volume 4'b1000)");
            reset_dut();
            i = 16'h0005;
            volume = 4'b1000;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h0028);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Reset Override during operation");
            reset_dut();
            i = 16'hFFFF;
            volume = 4'b0001;
            @(posedge clk_i);
            #1;
            rst_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Max scaling (8x) of high value");
            reset_dut();
            i = 16'h2000;
            volume = 4'b1000;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_o;
        begin
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
        $dumpvars(0,clk_i, i, rst_i, volume, o);
    end

endmodule

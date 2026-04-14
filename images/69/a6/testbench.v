`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg reset;
    wire [7:0] gray_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .reset(reset),
        .gray_count(gray_count)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            reset = 1;
            enable = 0;
            repeat(2) @(negedge clock);
            reset = 0;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clock);
            enable = 1;
            @(negedge clock);
            enable = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clock);
            enable = 1;
            repeat(4) @(negedge clock);
            enable = 0;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clock);
            enable = 1;
            repeat(2) @(negedge clock);
            enable = 0;
            repeat(3) @(negedge clock);
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clock);
            enable = 1;
            repeat(15) @(negedge clock);
            enable = 0;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge clock);
            enable = 1;
            repeat(255) @(negedge clock);
            enable = 0;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(negedge clock);
            enable = 1;
            repeat(256) @(negedge clock);
            enable = 0;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_gray_count;
        begin
            if (expected_gray_count === (expected_gray_count ^ gray_count ^ expected_gray_count)) begin
                $display("PASS");
                $display("  Outputs: gray_count=%h",
                         gray_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_count=%h",
                         expected_gray_count);
                $display("  Got:      gray_count=%h",
                         gray_count);
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
        $dumpvars(0,clock, enable, reset, gray_count);
    end

endmodule

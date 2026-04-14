`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [3:0] count;
    wire [3:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .count(count),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single increment check", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Increment multiple times (count to 5)", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'h5, 4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Hold value when enable is low", test_num);
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            en = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3, 4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Counter wraparound (15 -> 0)", test_num);
            reset_dut();
            en = 1;
            repeat(16) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Synchronous reset mid-count", test_num);
            reset_dut();
            en = 1;
            repeat(8) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            en = 0;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Reach maximum value (15)", test_num);
            reset_dut();
            en = 1;
            repeat(15) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'hF, 4'hF);
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
        input [3:0] expected_count;
        input [3:0] expected_leds;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: count=%h, leds=%h",
                         count, leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, leds=%h",
                         expected_count, expected_leds);
                $display("  Got:      count=%h, leds=%h",
                         count, leds);
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
        $dumpvars(0,clk, en, rst, count, leds);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg go;
    reg reset;
    wire green_led;
    wire red_led;
    wire yellow_led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .go(go),
        .reset(reset),
        .green_led(green_led),
        .red_led(red_led),
        .yellow_led(yellow_led)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            go = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset state check...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Transition to RED_YELLOW...");
            test_num = 2;
            reset_dut();
            go = 1;


            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Transition to GREEN...");
            test_num = 3;
            reset_dut();
            go = 1;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Transition to YELLOW...");
            test_num = 4;
            reset_dut();
            go = 1;

            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Full cycle back to RED...");
            test_num = 5;
            reset_dut();
            go = 1;

            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Verify state hold when go=0...");
            test_num = 6;
            reset_dut();
            go = 1;
            @(posedge clk);
            #1;
            go = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Reset from mid-sequence...");
            test_num = 7;
            reset_dut();
            go = 1;
            repeat(2) @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(0, 1, 0);
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
        input expected_green_led;
        input expected_red_led;
        input expected_yellow_led;
        begin
            if (expected_green_led === (expected_green_led ^ green_led ^ expected_green_led) &&
                expected_red_led === (expected_red_led ^ red_led ^ expected_red_led) &&
                expected_yellow_led === (expected_yellow_led ^ yellow_led ^ expected_yellow_led)) begin
                $display("PASS");
                $display("  Outputs: green_led=%b, red_led=%b, yellow_led=%b",
                         green_led, red_led, yellow_led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green_led=%b, red_led=%b, yellow_led=%b",
                         expected_green_led, expected_red_led, expected_yellow_led);
                $display("  Got:      green_led=%b, red_led=%b, yellow_led=%b",
                         green_led, red_led, yellow_led);
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
        $dumpvars(0,clk, go, reset, green_led, red_led, yellow_led);
    end

endmodule

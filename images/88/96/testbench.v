`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [1:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Initial State", test_num);
            reset_dut();

            last_led_state = leds;

            #1;


            check_outputs(last_led_state);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Waiting for 1,000,000 cycles to observe toggle", test_num);


            repeat(1000000) @(posedge clk);
            #1;


            #1;



            check_outputs(~last_led_state);
            last_led_state = leds;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Waiting for another 1,000,000 cycles", test_num);
            repeat(1000000) @(posedge clk);
            #1;


            #1;



            check_outputs(~last_led_state);
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
        input [1:0] expected_leds;
        begin
            if (expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: leds=%h",
                         leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds=%h",
                         expected_leds);
                $display("  Got:      leds=%h",
                         leds);
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
        $dumpvars(0,clk, leds);
    end

endmodule

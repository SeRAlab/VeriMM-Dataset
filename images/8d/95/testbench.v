`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg decrease_brightness;
    reg increase_brightness;
    reg turn_off;
    reg turn_on;
    wire [1:0] dimmer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .decrease_brightness(decrease_brightness),
        .increase_brightness(increase_brightness),
        .turn_off(turn_off),
        .turn_on(turn_on),
        .dimmer(dimmer)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            turn_on = 0;
            turn_off = 0;
            increase_brightness = 0;
            decrease_brightness = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            turn_on = 1;
            @(negedge clk);
            turn_on = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk) turn_on = 1;
            @(negedge clk) turn_on = 0;
            @(negedge clk) increase_brightness = 1;
            @(negedge clk) increase_brightness = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk) turn_on = 1;
            @(negedge clk) turn_on = 0;
            @(negedge clk) increase_brightness = 1;
            @(negedge clk) increase_brightness = 0;
            @(negedge clk) decrease_brightness = 1;
            @(negedge clk) decrease_brightness = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk) turn_on = 1;
            @(negedge clk) turn_on = 0;
            @(negedge clk) turn_off = 1;
            @(negedge clk) turn_off = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk) turn_on = 1;
            @(negedge clk) turn_on = 0;
            @(negedge clk) increase_brightness = 1;
            @(negedge clk) increase_brightness = 0;
            @(negedge clk) turn_off = 1;
            @(negedge clk) turn_off = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(negedge clk) increase_brightness = 1;
            @(negedge clk) increase_brightness = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            @(negedge clk) decrease_brightness = 1;
            @(negedge clk) decrease_brightness = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            @(negedge clk) turn_on = 1;
            @(negedge clk) turn_on = 0;
            #2 areset = 1;
            #2 #1;
 check_outputs(2'b00);
            areset = 0;
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
        input [1:0] expected_dimmer;
        begin
            if (expected_dimmer === (expected_dimmer ^ dimmer ^ expected_dimmer)) begin
                $display("PASS");
                $display("  Outputs: dimmer=%h",
                         dimmer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dimmer=%h",
                         expected_dimmer);
                $display("  Got:      dimmer=%h",
                         dimmer);
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
        $dumpvars(0,areset, clk, decrease_brightness, increase_brightness, turn_off, turn_on, dimmer);
    end

endmodule

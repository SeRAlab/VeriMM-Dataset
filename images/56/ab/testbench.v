`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    wire [7:0] counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .counter(counter)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            $display("Resetting/Synchronizing DUT to 0...");

            if (counter !== 8'd0) begin
                repeat (256) begin
                    if (counter === 8'd255) break;
                    @(posedge clock);
                end
                @(posedge clock);
            end
            #1;
            if (counter !== 8'd0) begin
                $display("Warning: Could not synchronize counter to 0. Current value: %h", counter);
            end
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Increment Check", test_num);
            reset_dut();
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiple Increments (16 steps)", test_num);
            reset_dut();
            repeat (16) @(posedge clock);
            #1;
            #1;

            check_outputs(8'd16);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Midpoint Value Check (128)", test_num);
            reset_dut();
            repeat (128) @(posedge clock);
            #1;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Value Check (255)", test_num);
            reset_dut();
            repeat (255) @(posedge clock);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Wrap Around (256 cycles)", test_num);
            reset_dut();
            repeat (256) @(posedge clock);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Wrap Around and Continue (260 cycles)", test_num);
            reset_dut();
            repeat (260) @(posedge clock);
            #1;
            #1;

            check_outputs(8'd4);
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
        input [7:0] expected_counter;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter)) begin
                $display("PASS");
                $display("  Outputs: counter=%h",
                         counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h",
                         expected_counter);
                $display("  Got:      counter=%h",
                         counter);
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
        $dumpvars(0,clock, counter);
    end

endmodule

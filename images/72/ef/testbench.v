`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    wire clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk)
    );

        task reset_dut;

        begin
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Checking initial state initialization...", test_num);

            if (clk === 1'b0 || clk === 1'b1) begin
                #1;

                check_outputs(clk);
            end else begin
                #1;

                check_outputs(1'b0);
            end
        end
        endtask

    task testcase002;

        reg initial_state;
        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Checking for the first toggle event...", test_num);
            initial_state = clk;

            @(clk);
            #1;

            check_outputs(~initial_state);
        end
        endtask

    task testcase003;

        reg state_after_first_toggle;
        begin
            test_num = 3;
            reset_dut();
            @(clk);
            state_after_first_toggle = clk;
            @(clk);
            $display("Testcase %0d: Checking for the second toggle event...", test_num);
            #1;

            check_outputs(~state_after_first_toggle);
        end
        endtask

    task testcase004;

        reg state_after_second_toggle;
        begin
            test_num = 4;
            reset_dut();
            @(clk);
            @(clk);
            state_after_second_toggle = clk;
            @(clk);
            $display("Testcase %0d: Checking for the third toggle event...", test_num);
            #1;

            check_outputs(~state_after_second_toggle);
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
        input expected_clk;
        begin
            if (expected_clk === (expected_clk ^ clk ^ expected_clk)) begin
                $display("PASS");
                $display("  Outputs: clk=%b",
                         clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b",
                         expected_clk);
                $display("  Got:      clk=%b",
                         clk);
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
        $dumpvars(0,clk);
    end

endmodule

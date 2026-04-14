`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rst_n;
    wire res_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rst_n(rst_n),
        .res_n(res_n)
    );

    // Clock generation (10ns period)
    initial begin
        rst_n = 0;
        forever #5 rst_n = ~rst_n;
    end

        task reset_dut;

        begin

            repeat(2) @(posedge rst_n);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Check res_n HIGH immediately after falling edge of rst_n", test_num);
            @(negedge rst_n);
            #0.1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Check res_n returns to LOW after the transition event", test_num);
            @(negedge rst_n);
            #2.0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Check res_n stays LOW during rising edge of rst_n", test_num);
            @(posedge rst_n);
            #0.1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Check res_n is LOW while rst_n is stable HIGH", test_num);
            @(posedge rst_n);
            #2.5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Check res_n is LOW while rst_n is stable LOW (post-edge)", test_num);
            @(negedge rst_n);
            #4.5;
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
        input expected_res_n;
        begin
            if (expected_res_n === (expected_res_n ^ res_n ^ expected_res_n)) begin
                $display("PASS");
                $display("  Outputs: res_n=%b",
                         res_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res_n=%b",
                         expected_res_n);
                $display("  Got:      res_n=%b",
                         res_n);
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
        $dumpvars(0,rst_n, res_n);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg quarter;
    reg reset;
    wire item_dispensed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .quarter(quarter),
        .reset(reset),
        .item_dispensed(item_dispensed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            quarter = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Three consecutive quarters", test_num);
            reset_dut();

            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Two quarters (insufficient)", test_num);
            reset_dut();
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset during accepting state", test_num);
            reset_dut();
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 1;
            reset = 1;
            @(negedge clk); reset = 0;
            @(negedge clk); quarter = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify return to Idle after dispense", test_num);
            reset_dut();

            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 0;

            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Two full transactions in a row", test_num);
            reset_dut();

            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 0;

            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 1;
            @(negedge clk); quarter = 0;
            #1;

            check_outputs(1'b1);
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
        input expected_item_dispensed;
        begin
            if (expected_item_dispensed === (expected_item_dispensed ^ item_dispensed ^ expected_item_dispensed)) begin
                $display("PASS");
                $display("  Outputs: item_dispensed=%b",
                         item_dispensed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: item_dispensed=%b",
                         expected_item_dispensed);
                $display("  Got:      item_dispensed=%b",
                         item_dispensed);
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
        $dumpvars(0,clk, quarter, reset, item_dispensed);
    end

endmodule

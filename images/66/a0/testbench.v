`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dime;
    reg nickel;
    reg quarter;
    reg reset;
    wire candy_dispense;
    wire [7:0] display;
    wire soda_dispense;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dime(dime),
        .nickel(nickel),
        .quarter(quarter),
        .reset(reset),
        .candy_dispense(candy_dispense),
        .display(display),
        .soda_dispense(soda_dispense)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            nickel = 0;
            dime = 0;
            quarter = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            nickel = 1; @(posedge clk); #1 nickel = 0;
            @(posedge clk); #1;
            nickel = 1; @(posedge clk); #1 nickel = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1, 8'd0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            dime = 1; @(posedge clk); #1 dime = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1, 8'd0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            quarter = 1; @(posedge clk); #1 quarter = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(0, 8'd0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            nickel = 1; @(posedge clk); #1 nickel = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(0, 8'd5, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            nickel = 1; @(posedge clk); #1 nickel = 0;
            @(posedge clk); #1;
            dime = 1; @(posedge clk); #1 dime = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1, 8'd5, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            dime = 1; @(posedge clk); #1 dime = 0;
            @(posedge clk); #1;
            dime = 1; @(posedge clk); #1 dime = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1, 8'd0, 0);
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
        input expected_candy_dispense;
        input [7:0] expected_display;
        input expected_soda_dispense;
        begin
            if (expected_candy_dispense === (expected_candy_dispense ^ candy_dispense ^ expected_candy_dispense) &&
                expected_display === (expected_display ^ display ^ expected_display) &&
                expected_soda_dispense === (expected_soda_dispense ^ soda_dispense ^ expected_soda_dispense)) begin
                $display("PASS");
                $display("  Outputs: candy_dispense=%b, display=%h, soda_dispense=%b",
                         candy_dispense, display, soda_dispense);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: candy_dispense=%b, display=%h, soda_dispense=%b",
                         expected_candy_dispense, expected_display, expected_soda_dispense);
                $display("  Got:      candy_dispense=%b, display=%h, soda_dispense=%b",
                         candy_dispense, display, soda_dispense);
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
        $dumpvars(0,clk, dime, nickel, quarter, reset, candy_dispense, display, soda_dispense);
    end

endmodule

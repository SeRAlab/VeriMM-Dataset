`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg coin;
    reg reset;
    wire dispense;
    wire [11:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin(coin),
        .reset(reset),
        .dispense(dispense),
        .display(display)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            coin = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, MSG_IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            coin = 1;
            @(posedge clk);
            #1 coin = 0;

            #1;


            check_outputs(1'b1, MSG_THANK_YOU);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            coin = 1;
            @(posedge clk);
            #1 coin = 0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, MSG_IDLE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            coin = 1;
            @(posedge clk);
            #1 coin = 0;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            #1;

            check_outputs(1'b0, MSG_IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            coin = 1; @(posedge clk); #1 coin = 0;
            repeat(5) @(posedge clk);

            coin = 1; @(posedge clk); #1 coin = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0, MSG_IDLE);
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
        input expected_dispense;
        input [11:0] expected_display;
        begin
            if (expected_dispense === (expected_dispense ^ dispense ^ expected_dispense) &&
                expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: dispense=%b, display=%h",
                         dispense, display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispense=%b, display=%h",
                         expected_dispense, expected_display);
                $display("  Got:      dispense=%b, display=%h",
                         dispense, display);
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
        $dumpvars(0,clk, coin, reset, dispense, display);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] coin;
    reg [1:0] item;
    reg reset;
    wire [1:0] change;
    wire dispense;
    wire item1;
    wire item2;
    wire item3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin(coin),
        .item(item),
        .reset(reset),
        .change(change),
        .dispense(dispense),
        .item1(item1),
        .item2(item2),
        .item3(item3)
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
            item = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            coin = 2'b01;
            @(posedge clk);
            coin = 0;
            item = 2'b01;
            #1;

            check_outputs(2'b00, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            coin = 2'b10;
            @(posedge clk);
            coin = 0;
            item = 2'b10;
            #1;

            check_outputs(2'b00, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            coin = 2'b10;
            @(posedge clk);
            coin = 0;
            item = 2'b01;
            #1;

            check_outputs(2'b01, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            coin = 2'b01;
            @(posedge clk);
            coin = 0;
            item = 2'b10;
            #1;

            check_outputs(2'b00, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            coin = 2'b10; @(posedge clk);
            coin = 2'b01; @(posedge clk);
            coin = 0;
            item = 2'b11;
            @(posedge clk);


            coin = 2'b10; @(posedge clk);
            coin = 2'b10; @(posedge clk);
            coin = 0;
            item = 2'b11;
            #1;

            check_outputs(2'b00, 1'b0, 1'b1, 1'b1, 1'b0);
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
        input [1:0] expected_change;
        input expected_dispense;
        input expected_item1;
        input expected_item2;
        input expected_item3;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_dispense === (expected_dispense ^ dispense ^ expected_dispense) &&
                expected_item1 === (expected_item1 ^ item1 ^ expected_item1) &&
                expected_item2 === (expected_item2 ^ item2 ^ expected_item2) &&
                expected_item3 === (expected_item3 ^ item3 ^ expected_item3)) begin
                $display("PASS");
                $display("  Outputs: change=%h, dispense=%b, item1=%b, item2=%b, item3=%b",
                         change, dispense, item1, item2, item3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, dispense=%b, item1=%b, item2=%b, item3=%b",
                         expected_change, expected_dispense, expected_item1, expected_item2, expected_item3);
                $display("  Got:      change=%h, dispense=%b, item1=%b, item2=%b, item3=%b",
                         change, dispense, item1, item2, item3);
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
        $dumpvars(0,clk, coin, item, reset, change, dispense, item1, item2, item3);
    end

endmodule

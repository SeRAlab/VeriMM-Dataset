`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg coin;
    reg dispense;
    reg reset;
    wire [2:0] change;
    wire item_dispensed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .coin(coin),
        .dispense(dispense),
        .reset(reset),
        .change(change),
        .item_dispensed(item_dispensed)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        coin = 0;
        dispense = 0;
        @(posedge clock);
        #1 reset = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Exact amount (4 quarters)", test_num);
        reset_dut();


        repeat(4) begin
            coin = 1; @(posedge clock);
            #1 coin = 0; @(posedge clock);
        end


        dispense = 1; @(posedge clock);
        #1 dispense = 0;


        @(posedge clock);
        #1 #1;
 check_outputs(3'd0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Excess amount (5 quarters)", test_num);
        reset_dut();


        repeat(5) begin
            coin = 1; @(posedge clock);
            #1 coin = 0; @(posedge clock);
        end


        dispense = 1; @(posedge clock);
        #1 dispense = 0;


        @(posedge clock);
        #1 #1;
 check_outputs(3'd1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Insufficient amount (3 quarters)", test_num);
        reset_dut();


        repeat(3) begin
            coin = 1; @(posedge clock);
            #1 coin = 0; @(posedge clock);
        end


        dispense = 1; @(posedge clock);
        #1 dispense = 0;


        @(posedge clock);
        #1 #1;
 check_outputs(3'd0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High change amount (7 quarters)", test_num);
        reset_dut();


        repeat(7) begin
            coin = 1; @(posedge clock);
            #1 coin = 0; @(posedge clock);
        end


        dispense = 1; @(posedge clock);
        #1 dispense = 0;


        @(posedge clock);
        #1 #1;
 check_outputs(3'd3, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset mid-transaction", test_num);
        reset_dut();


        repeat(2) begin
            coin = 1; @(posedge clock);
            #1 coin = 0; @(posedge clock);
        end


        reset_dut();


        dispense = 1; @(posedge clock);
        #1 dispense = 0;

        @(posedge clock);
        #1 #1;
 check_outputs(3'd0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: No coins, immediate dispense", test_num);
        reset_dut();

        dispense = 1; @(posedge clock);
        #1 dispense = 0;

        @(posedge clock);
        #1 #1;
 check_outputs(3'd0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Back-to-back transactions", test_num);
        reset_dut();


        repeat(4) begin
            coin = 1; @(posedge clock); #1 coin = 0; @(posedge clock);
        end
        dispense = 1; @(posedge clock); #1 dispense = 0; @(posedge clock);


        repeat(5) begin
            coin = 1; @(posedge clock); #1 coin = 0; @(posedge clock);
        end
        dispense = 1; @(posedge clock); #1 dispense = 0;

        @(posedge clock);
        #1 #1;
 check_outputs(3'd1, 1'b1);
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
        input [2:0] expected_change;
        input expected_item_dispensed;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_item_dispensed === (expected_item_dispensed ^ item_dispensed ^ expected_item_dispensed)) begin
                $display("PASS");
                $display("  Outputs: change=%h, item_dispensed=%b",
                         change, item_dispensed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, item_dispensed=%b",
                         expected_change, expected_item_dispensed);
                $display("  Got:      change=%h, item_dispensed=%b",
                         change, item_dispensed);
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
        $dumpvars(0,clock, coin, dispense, reset, change, item_dispensed);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] coin;
    reg reset;
    reg [3:0] selection;
    wire [3:0] change;
    wire dispense;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin(coin),
        .reset(reset),
        .selection(selection),
        .change(change),
        .dispense(dispense)
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
            selection = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Product 1, exact amount (5)");


            coin = 4'd5;
            @(posedge clk);
            #1 coin = 0;
            @(posedge clk);


            selection = 4'd1;
            @(posedge clk);
            #1 selection = 0;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Product 1, overpayment (10 - 5 = 5 change)");


            coin = 4'd10;
            @(posedge clk);
            #1 coin = 0;
            @(posedge clk);


            selection = 4'd1;
            @(posedge clk);
            #1 selection = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Product 2, exact amount (10)");


            coin = 4'd10;
            @(posedge clk);
            #1 coin = 0;
            @(posedge clk);


            selection = 4'd2;
            @(posedge clk);
            #1 selection = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Cumulative coin insertion (5+10=15, select Product 2, change 5)");


            coin = 4'd5;
            @(posedge clk);
            #1 coin = 0;
            @(posedge clk);


            coin = 4'd10;
            @(posedge clk);
            #1 coin = 0;
            @(posedge clk);


            selection = 4'd2;
            @(posedge clk);
            #1 selection = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd5, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Insufficient funds for Product 1 (Insert 2, Price 5)");


            coin = 4'd2;
            @(posedge clk);
            #1 coin = 0;
            @(posedge clk);


            selection = 4'd1;
            @(posedge clk);
            #1 selection = 0;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Reset mid-transaction");


            coin = 4'd10;
            @(posedge clk);
            #1 coin = 0;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);


            selection = 4'd1;
            @(posedge clk);
            #1 selection = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'd0, 1'b0);
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
        input [3:0] expected_change;
        input expected_dispense;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_dispense === (expected_dispense ^ dispense ^ expected_dispense)) begin
                $display("PASS");
                $display("  Outputs: change=%h, dispense=%b",
                         change, dispense);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, dispense=%b",
                         expected_change, expected_dispense);
                $display("  Got:      change=%h, dispense=%b",
                         change, dispense);
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
        $dumpvars(0,clk, coin, reset, selection, change, dispense);
    end

endmodule

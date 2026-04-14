`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] payment;
    reg reset;
    reg [3:0] selection;
    wire [7:0] change;
    wire [3:0] dispensing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .payment(payment),
        .reset(reset),
        .selection(selection),
        .change(change),
        .dispensing(dispensing)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            selection = 0;
            payment = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selection 1, Exact Payment (10)", test_num);
            reset_dut();

            selection = 4'd1;
            @(posedge clk); #1;

            payment = 8'd10;
            @(posedge clk); #1;

            #1;


            check_outputs(8'd0, 4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selection 2, Overpayment (50 for price 20)", test_num);
            reset_dut();

            selection = 4'd2;
            @(posedge clk); #1;

            payment = 8'd50;
            @(posedge clk); #1;

            #1;


            check_outputs(8'd30, 4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selection 3, Insufficient Payment (5 for price 30)", test_num);
            reset_dut();

            selection = 4'd3;
            @(posedge clk); #1;

            payment = 8'd5;
            @(posedge clk); #1;

            #1;


            check_outputs(8'd0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selection 15, Max Payment (255)", test_num);
            reset_dut();

            selection = 4'd15;
            @(posedge clk); #1;

            payment = 8'd255;
            @(posedge clk); #1;


            #1;



            check_outputs(8'd105, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset mid-transaction", test_num);
            reset_dut();

            selection = 4'd1;
            @(posedge clk); #1;

            reset = 1;
            @(posedge clk); #1;
            reset = 0;

            #1;


            check_outputs(8'd0, 4'd0);
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
        input [7:0] expected_change;
        input [3:0] expected_dispensing;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_dispensing === (expected_dispensing ^ dispensing ^ expected_dispensing)) begin
                $display("PASS");
                $display("  Outputs: change=%h, dispensing=%h",
                         change, dispensing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, dispensing=%h",
                         expected_change, expected_dispensing);
                $display("  Got:      change=%h, dispensing=%h",
                         change, dispensing);
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
        $dumpvars(0,clk, payment, reset, selection, change, dispensing);
    end

endmodule

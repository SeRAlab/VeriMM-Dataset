`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg purchase;
    reg reset;
    wire [3:0] display;
    wire item_dispensed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .purchase(purchase),
        .reset(reset),
        .display(display),
        .item_dispensed(item_dispensed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 4'b0000;
            purchase = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase 001: Verifying IDLE state after reset");
            reset_dut();


            #1 #1;
 check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase 002: Purchase Item 1 - Check Dispensing Signal");
            reset_dut();

            purchase = 1;
            data = 4'd1;
            @(posedge clk);

            #1 purchase = 0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(display, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase 003: Purchase Item 2 - Check Dispensing Signal");
            reset_dut();

            purchase = 1;
            data = 4'd2;
            @(posedge clk);

            #1 purchase = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(display, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase 004: Purchase Item 3 - Check Dispensing Signal");
            reset_dut();

            purchase = 1;
            data = 4'd3;
            @(posedge clk);

            #1 purchase = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(display, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase 005: Full Cycle - Check return to IDLE after DISPENSING");
            reset_dut();

            purchase = 1;
            data = 4'd1;
            @(posedge clk);
            #1 purchase = 0;
            @(posedge clk);
            @(posedge clk);

            #1;

            #1;


            check_outputs(4'h0, 1'b0);
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
        input [3:0] expected_display;
        input expected_item_dispensed;
        begin
            if (expected_display === (expected_display ^ display ^ expected_display) &&
                expected_item_dispensed === (expected_item_dispensed ^ item_dispensed ^ expected_item_dispensed)) begin
                $display("PASS");
                $display("  Outputs: display=%h, item_dispensed=%b",
                         display, item_dispensed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display=%h, item_dispensed=%b",
                         expected_display, expected_item_dispensed);
                $display("  Got:      display=%h, item_dispensed=%b",
                         display, item_dispensed);
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
        $dumpvars(0,clk, data, purchase, reset, display, item_dispensed);
    end

endmodule

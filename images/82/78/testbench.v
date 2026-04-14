`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    wire empty;
    wire full;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .empty(empty),
        .full(full),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Behavior", test_num);
            reset_dut();
            #1;

            check_outputs(1'b1, 1'b0, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Increment", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(1'b0, 1'b0, 32'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Count to 5", test_num);
            reset_dut();
            en = 1;
            for(i = 0; i < 5; i = i + 1) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(1'b0, 1'b0, 32'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify 'en' holds value", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            @(posedge clk);
            #1 en = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 32'd2);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reach full limit (assuming limit=15)", test_num);
            reset_dut();
            en = 1;
            for(i = 0; i < 15; i = i + 1) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(1'b0, 1'b1, 32'd15);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rollover behavior", test_num);
            reset_dut();
            en = 1;
            for(i = 0; i < 16; i = i + 1) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(1'b1, 1'b0, 32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous reset priority", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            en = 0;
            #1;

            check_outputs(1'b1, 1'b0, 32'd0);
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
        input expected_empty;
        input expected_full;
        input [31:0] expected_out;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, out=%h",
                         empty, full, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, out=%h",
                         expected_empty, expected_full, expected_out);
                $display("  Got:      empty=%b, full=%b, out=%h",
                         empty, full, out);
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
        $dumpvars(0,clk, en, reset, empty, full, out);
    end

endmodule

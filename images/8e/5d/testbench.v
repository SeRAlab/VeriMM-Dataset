`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [3:0] data;
    reg load;
    reg up_down;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .data(data),
        .load(load),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        clear = 1;
        load = 0;
        up_down = 0;
        data = 4'b0000;
        @(negedge clk);
        clear = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Synchronous Load", test_num);
        reset_dut();
        @(negedge clk);
        data = 4'hA;
        load = 1;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Up Counting (0 to 3)", test_num);
        reset_dut();
        @(negedge clk);
        up_down = 1;
        repeat(3) @(negedge clk);
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Down Counting (Load 8 then decrement 2)", test_num);
        reset_dut();
        @(negedge clk);
        data = 4'h8;
        load = 1;
        @(negedge clk);
        load = 0;
        up_down = 0;
        repeat(2) @(negedge clk);
        #1;

        check_outputs(4'h6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Overflow Wrap-around (15 to 0)", test_num);
        reset_dut();
        @(negedge clk);
        data = 4'hF;
        load = 1;
        @(negedge clk);
        load = 0;
        up_down = 1;
        @(negedge clk);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Underflow Wrap-around (0 to 15)", test_num);
        reset_dut();
        @(negedge clk);
        up_down = 0;
        @(negedge clk);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Priority Check (Clear vs Load)", test_num);
        reset_dut();
        @(negedge clk);
        data = 4'h5;
        load = 1;
        clear = 1;
        @(negedge clk);
        clear = 0;
        load = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Priority Check (Load vs Counting)", test_num);
        reset_dut();
        @(negedge clk);
        data = 4'hE;
        load = 1;
        up_down = 1;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(4'hE);
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
        testcase008();
        
        
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clear, clk, data, load, up_down, count);
    end

endmodule

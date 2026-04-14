`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg direction;
    reg load;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .direction(direction),
        .load(load),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        load = 1;
        direction = 1;
        data_in = 4'h0;
        #15;
        reset = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Reset");
        test_num = test_num + 1;
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Load Data 4'hA");
        test_num = test_num + 1;
        reset_dut();
        data_in = 4'hA;
        load = 0;
        @(posedge clk);
        #1;
        load = 1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    integer i;
    begin
        $display("Testcase 003: Increment 5 times");
        test_num = test_num + 1;
        reset_dut();
        direction = 1;
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Decrement from 0 (Underflow)");
        test_num = test_num + 1;
        reset_dut();
        direction = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Overflow Wrap-around (15 to 0)");
        test_num = test_num + 1;
        reset_dut();

        data_in = 4'hF;
        load = 0;
        @(posedge clk);
        #1;
        load = 1;
        direction = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    integer i;
    begin
        $display("Testcase 006: Load 4'h5 and decrement 3 times");
        test_num = test_num + 1;
        reset_dut();
        data_in = 4'h5;
        load = 0;
        @(posedge clk);
        #1;
        load = 1;
        direction = 0;
        for (i = 0; i < 3; i = i + 1) begin
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Switching Directions");
        test_num = test_num + 1;
        reset_dut();
        direction = 1;
        repeat(4) @(posedge clk);
        #1;
        direction = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Load priority over counting");
        test_num = test_num + 1;
        reset_dut();
        data_in = 4'h7;
        load = 0;
        direction = 1;
        repeat(3) @(posedge clk);
        #1;

        #1;


        check_outputs(4'h7);
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
        $dumpvars(0,clk, data_in, direction, load, reset, count);
    end

endmodule

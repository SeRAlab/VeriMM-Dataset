`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rx;
    reg [15:0] sw;
    wire [15:0] led;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rx(rx),
        .sw(sw),
        .led(led),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sw = 16'h0000;
            rx = 1'b0;
            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            sw = 16'h0000;
            rx = 1'b0;
            repeat(20) @(posedge clk);
            $display("Test Case 001: All Inputs Low");
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            sw = 16'hFFFF;
            rx = 1'b1;
            repeat(20) @(posedge clk);
            $display("Test Case 002: All Inputs High");
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            sw = 16'hAAAA;
            rx = 1'b0;
            repeat(20) @(posedge clk);
            $display("Test Case 003: Pattern AAAA");
            #1;

            check_outputs(16'hAAAA, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            sw = 16'h5555;
            rx = 1'b1;
            repeat(20) @(posedge clk);
            $display("Test Case 004: Pattern 5555");
            #1;

            check_outputs(16'h5555, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            sw = 16'h8001;
            rx = 1'b0;
            repeat(20) @(posedge clk);
            $display("Test Case 005: Boundary Bits (8001)");
            #1;

            check_outputs(16'h8001, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            sw = 16'h1234;
            rx = 1'b1;
            repeat(20) @(posedge clk);
            $display("Test Case 006: Pattern 1234");
            #1;

            check_outputs(16'h1234, 1'b1);
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
        input [15:0] expected_led;
        input expected_tx;
        begin
            if (expected_led === (expected_led ^ led ^ expected_led) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: led=%h, tx=%b",
                         led, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h, tx=%b",
                         expected_led, expected_tx);
                $display("  Got:      led=%h, tx=%b",
                         led, tx);
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
        $dumpvars(0,clk, rx, sw, led, tx);
    end

endmodule

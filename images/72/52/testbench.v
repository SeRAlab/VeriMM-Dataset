`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] load_val;
    reg sload;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load_val(load_val),
        .sload(sload),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sload = 1;
            load_val = 8'h00;
            @(posedge clk);
            #1 sload = 0;
            load_val = 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Testing synchronous load of 8'hA5", test_num);
            sload = 1;
            load_val = 8'hA5;
            @(posedge clk);
            #1 sload = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Testing single decrement after loading 8'h05", test_num);
            sload = 1;
            load_val = 8'h05;
            @(posedge clk);
            #1 sload = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Testing multiple decrements (10 cycles) starting from 8'h14", test_num);
            sload = 1;
            load_val = 8'h14;
            @(posedge clk);
            #1 sload = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Testing underflow wrap-around (0 to 255)", test_num);

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Testing underflow from 8'h01 over 2 cycles", test_num);
            sload = 1;
            load_val = 8'h01;
            @(posedge clk);
            #1 sload = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Testing decrement from max value 8'hFF", test_num);
            sload = 1;
            load_val = 8'hFF;
            @(posedge clk);
            #1 sload = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFD);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: Verifying load signal overrides decrement when held high", test_num);
            sload = 1;
            load_val = 8'hAA;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
            sload = 0;
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
        input [7:0] expected_count;
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
        $dumpvars(0,clk, load_val, sload, count);
    end

endmodule

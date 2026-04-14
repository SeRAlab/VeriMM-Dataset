`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mosi;
    reg rst;
    wire cs;
    wire miso;
    wire sclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mosi(mosi),
        .rst(rst),
        .cs(cs),
        .miso(miso),
        .sclk(sclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            mosi = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Running standard 8-bit transaction", test_num);
            reset_dut();



            repeat(40) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Transaction with MOSI high", test_num);
            reset_dut();

            mosi = 1;
            repeat(40) @(posedge clk);
            mosi = 0;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Reset during transaction", test_num);
            reset_dut();


            repeat(5) @(posedge clk);


            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;


            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_cs;
        input expected_miso;
        input expected_sclk;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, miso=%b, sclk=%b",
                         cs, miso, sclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, miso=%b, sclk=%b",
                         expected_cs, expected_miso, expected_sclk);
                $display("  Got:      cs=%b, miso=%b, sclk=%b",
                         cs, miso, sclk);
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
        $dumpvars(0,clk, mosi, rst, cs, miso, sclk);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg init;
    reg reset;
    wire clkadc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .init(init),
        .reset(reset),
        .clkadc(clkadc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        init = 0;
        repeat(5) @(posedge clk);
        #1 reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Checking clkadc is LOW before 50,000 cycles", test_num);
        reset_dut();
        init = 1;

        repeat(25000) @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Checking clkadc is HIGH after 50,000 cycles", test_num);
        reset_dut();
        init = 1;

        repeat(60000) @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Checking clkadc returns to LOW after 100,000 cycles", test_num);
        reset_dut();
        init = 1;

        repeat(110000) @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Checking reset functionality during HIGH pulse", test_num);
        reset_dut();
        init = 1;

        repeat(75000) @(posedge clk);

        reset = 1;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Checking that clkadc stays LOW without init", test_num);
        reset_dut();
        init = 0;

        repeat(120000) @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
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
        input expected_clkadc;
        begin
            if (expected_clkadc === (expected_clkadc ^ clkadc ^ expected_clkadc)) begin
                $display("PASS");
                $display("  Outputs: clkadc=%b",
                         clkadc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clkadc=%b",
                         expected_clkadc);
                $display("  Got:      clkadc=%b",
                         clkadc);
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
        $dumpvars(0,clk, init, reset, clkadc);
    end

endmodule

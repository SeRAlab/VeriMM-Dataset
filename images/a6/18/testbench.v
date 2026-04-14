`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;

    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Checking reset to 0000", test_num);
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Checking state after 4 clock cycles", test_num);
        reset_dut();
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Checking state after 8 clock cycles", test_num);
        reset_dut();
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Checking state after 15 clock cycles", test_num);
        reset_dut();
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Checking wrap-around after 16 clock cycles", test_num);
        reset_dut();
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Checking synchronous reset while counting", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, reset, q);
    end

endmodule

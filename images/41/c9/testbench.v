`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [9:0] ring;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .ring(ring)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking reset state", test_num);
        reset_dut();

        #1;


        check_outputs(10'b0000000001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking 1 clock cycle after reset", test_num);
        reset_dut();
        @(negedge clk);
        #1;

        check_outputs(10'b0000000010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking 5 clock cycles after reset", test_num);
        reset_dut();
        repeat(5) @(negedge clk);
        #1;

        check_outputs(10'b0000100000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking 9 clock cycles after reset", test_num);
        reset_dut();
        repeat(9) @(negedge clk);
        #1;

        check_outputs(10'b1000000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking wrap-around (10 cycles)", test_num);
        reset_dut();
        repeat(10) @(negedge clk);
        #1;

        check_outputs(10'b0000000001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking 23 clock cycles (multiple wraps)", test_num);
        reset_dut();
        repeat(23) @(negedge clk);

        #1;


        check_outputs(10'b0000001000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking synchronous reset mid-operation", test_num);
        reset_dut();
        repeat(5) @(negedge clk);
        reset_dut();
        #1;

        check_outputs(10'b0000000001);
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
        input [9:0] expected_ring;
        begin
            if (expected_ring === (expected_ring ^ ring ^ expected_ring)) begin
                $display("PASS");
                $display("  Outputs: ring=%h",
                         ring);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ring=%h",
                         expected_ring);
                $display("  Got:      ring=%h",
                         ring);
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
        $dumpvars(0,clk, reset, ring);
    end

endmodule

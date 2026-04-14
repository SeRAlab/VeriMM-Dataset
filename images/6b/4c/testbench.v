`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in1;
    reg reset;
    wire clk_out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in1(clk_in1),
        .reset(reset),
        .clk_out1(clk_out1)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in1 = 0;
        forever #5 clk_in1 = ~clk_in1;
    end

        task reset_dut;

        begin
            reset = 1;
            #20;
            reset = 0;
            @(posedge clk_in1);
            #1;
        end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify reset state", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify toggle after 2 input clock cycles", test_num);
        reset_dut();
        repeat(2) @(posedge clk_in1);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify toggle after 4 input clock cycles", test_num);
        reset_dut();
        repeat(4) @(posedge clk_in1);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify toggle after 6 input clock cycles", test_num);
        reset_dut();
        repeat(6) @(posedge clk_in1);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mid-operation reset check", test_num);
        reset_dut();
        repeat(2) @(posedge clk_in1);
        #2;

        reset = 1;
        #20;
        #1;

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
        input expected_clk_out1;
        begin
            if (expected_clk_out1 === (expected_clk_out1 ^ clk_out1 ^ expected_clk_out1)) begin
                $display("PASS");
                $display("  Outputs: clk_out1=%b",
                         clk_out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out1=%b",
                         expected_clk_out1);
                $display("  Got:      clk_out1=%b",
                         clk_out1);
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
        $dumpvars(0,clk_in1, reset, clk_out1);
    end

endmodule

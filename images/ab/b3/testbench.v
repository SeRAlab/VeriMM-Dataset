`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire clk_div16;
    wire clk_div2;
    wire clk_div4;
    wire clk_div8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .clk_div16(clk_div16),
        .clk_div2(clk_div2),
        .clk_div4(clk_div4),
        .clk_div8(clk_div8)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        repeat(2) @(posedge clk);
        #2 reset = 0;

        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset = 1;
        #20;

        #1;


        check_outputs(0, 0, 0, 0);
        reset = 0;
        #5;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1, 0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(1, 1, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        repeat(5) @(posedge clk);
        #2;
        #1;

        check_outputs(1, 1, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        repeat(9) @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1, 1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        repeat(16) @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 0, 0);
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
        input expected_clk_div16;
        input expected_clk_div2;
        input expected_clk_div4;
        input expected_clk_div8;
        begin
            if (expected_clk_div16 === (expected_clk_div16 ^ clk_div16 ^ expected_clk_div16) &&
                expected_clk_div2 === (expected_clk_div2 ^ clk_div2 ^ expected_clk_div2) &&
                expected_clk_div4 === (expected_clk_div4 ^ clk_div4 ^ expected_clk_div4) &&
                expected_clk_div8 === (expected_clk_div8 ^ clk_div8 ^ expected_clk_div8)) begin
                $display("PASS");
                $display("  Outputs: clk_div16=%b, clk_div2=%b, clk_div4=%b, clk_div8=%b",
                         clk_div16, clk_div2, clk_div4, clk_div8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_div16=%b, clk_div2=%b, clk_div4=%b, clk_div8=%b",
                         expected_clk_div16, expected_clk_div2, expected_clk_div4, expected_clk_div8);
                $display("  Got:      clk_div16=%b, clk_div2=%b, clk_div4=%b, clk_div8=%b",
                         clk_div16, clk_div2, clk_div4, clk_div8);
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
        $dumpvars(0,clk, reset, clk_div16, clk_div2, clk_div4, clk_div8);
    end

endmodule

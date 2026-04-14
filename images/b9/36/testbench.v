`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire clk_div16;
    wire clk_div2;
    wire clk_div4;
    wire clk_div8;
    wire cntr_div16;
    wire cntr_div2;
    wire cntr_div4;
    wire cntr_div8;
    wire [3:0] counter;

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
        .clk_div8(clk_div8),
        .cntr_div16(cntr_div16),
        .cntr_div2(cntr_div2),
        .cntr_div4(cntr_div4),
        .cntr_div8(cntr_div8),
        .counter(counter)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #20;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Post-Reset Initialization", test_num);
            reset_dut();



            reset = 1;
            #20;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 4'h0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: After 1 Clock Cycle (Counter = 1)", test_num);
            reset_dut();

            #1;


            check_outputs(0, 1, 0, 0, 0, 1, 0, 0, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: After 4 Clock Cycles (Counter = 4)", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 1, 0, 0, 0, 1, 4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: After 8 Clock Cycles (Counter = 8)", test_num);
            reset_dut();
            repeat(7) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0, 0, 1, 0, 0, 0, 4'h8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Maximum Counter Value (Counter = 15)", test_num);
            reset_dut();
            repeat(14) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Counter Wrap-around (Counter = 16 -> 0)", test_num);
            reset_dut();
            repeat(15) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 4'h0);
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
        input expected_clk_div16;
        input expected_clk_div2;
        input expected_clk_div4;
        input expected_clk_div8;
        input expected_cntr_div16;
        input expected_cntr_div2;
        input expected_cntr_div4;
        input expected_cntr_div8;
        input [3:0] expected_counter;
        begin
            if (expected_clk_div16 === (expected_clk_div16 ^ clk_div16 ^ expected_clk_div16) &&
                expected_clk_div2 === (expected_clk_div2 ^ clk_div2 ^ expected_clk_div2) &&
                expected_clk_div4 === (expected_clk_div4 ^ clk_div4 ^ expected_clk_div4) &&
                expected_clk_div8 === (expected_clk_div8 ^ clk_div8 ^ expected_clk_div8) &&
                expected_cntr_div16 === (expected_cntr_div16 ^ cntr_div16 ^ expected_cntr_div16) &&
                expected_cntr_div2 === (expected_cntr_div2 ^ cntr_div2 ^ expected_cntr_div2) &&
                expected_cntr_div4 === (expected_cntr_div4 ^ cntr_div4 ^ expected_cntr_div4) &&
                expected_cntr_div8 === (expected_cntr_div8 ^ cntr_div8 ^ expected_cntr_div8) &&
                expected_counter === (expected_counter ^ counter ^ expected_counter)) begin
                $display("PASS");
                $display("  Outputs: clk_div16=%b, clk_div2=%b, clk_div4=%b, clk_div8=%b, cntr_div16=%b, cntr_div2=%b, cntr_div4=%b, cntr_div8=%b, counter=%h",
                         clk_div16, clk_div2, clk_div4, clk_div8, cntr_div16, cntr_div2, cntr_div4, cntr_div8, counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_div16=%b, clk_div2=%b, clk_div4=%b, clk_div8=%b, cntr_div16=%b, cntr_div2=%b, cntr_div4=%b, cntr_div8=%b, counter=%h",
                         expected_clk_div16, expected_clk_div2, expected_clk_div4, expected_clk_div8, expected_cntr_div16, expected_cntr_div2, expected_cntr_div4, expected_cntr_div8, expected_counter);
                $display("  Got:      clk_div16=%b, clk_div2=%b, clk_div4=%b, clk_div8=%b, cntr_div16=%b, cntr_div2=%b, cntr_div4=%b, cntr_div8=%b, counter=%h",
                         clk_div16, clk_div2, clk_div4, clk_div8, cntr_div16, cntr_div2, cntr_div4, cntr_div8, counter);
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
        $dumpvars(0,clk, reset, clk_div16, clk_div2, clk_div4, clk_div8, cntr_div16, cntr_div2, cntr_div4, cntr_div8, counter);
    end

endmodule

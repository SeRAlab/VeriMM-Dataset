`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg d1;
    reg d2;
    wire q1;
    wire q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .d1(d1),
        .d2(d2),
        .q1(q1),
        .q2(q2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            d1 = 0;
            d2 = 0;
            #10;
            clr = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Load Q1=1, Q2=0", test_num);
            reset_dut();
            d1 = 1;
            d2 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Load Q1=0, Q2=1", test_num);
            reset_dut();
            d1 = 0;
            d2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Load Q1=1, Q2=1", test_num);
            reset_dut();
            d1 = 1;
            d2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Asynchronous Clear assertion", test_num);
            reset_dut();
            d1 = 1;
            d2 = 1;
            @(posedge clk);
            #2;
            clr = 1;
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Clear priority over Clock", test_num);
            reset_dut();
            clr = 1;
            d1 = 1;
            d2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input stability without Clock edge", test_num);
            reset_dut();
            d1 = 1;
            d2 = 1;
            @(posedge clk);
            #2;
            @(negedge clk);
            d1 = 0;
            d2 = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Multiple Clock Cycles", test_num);
            reset_dut();

            d1 = 1; d2 = 0;
            @(posedge clk);
            #2;

            d1 = 0; d2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_q1;
        input expected_q2;
        begin
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2)) begin
                $display("PASS");
                $display("  Outputs: q1=%b, q2=%b",
                         q1, q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%b, q2=%b",
                         expected_q1, expected_q2);
                $display("  Got:      q1=%b, q2=%b",
                         q1, q2);
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
        $dumpvars(0,clk, clr, d1, d2, q1, q2);
    end

endmodule

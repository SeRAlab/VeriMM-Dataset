`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    wire green;
    wire red;
    wire yellow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .green(green),
        .red(red),
        .yellow(yellow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Green light active after start (cycle 3)", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #2 start = 0;
            repeat (2) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Yellow light active after 6 cycles", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #2 start = 0;
            repeat (5) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Red light active after 8 cycles", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #2 start = 0;
            repeat (7) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Cycle repeats back to Green after 10 cycles", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #2 start = 0;
            repeat (10) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Red light active at end of its duration (cycle 10)", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #2 start = 0;
            repeat (9) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Yellow light active at cycle 7", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #2 start = 0;
            repeat (6) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 1);
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
        input expected_green;
        input expected_red;
        input expected_yellow;
        begin
            if (expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red) &&
                expected_yellow === (expected_yellow ^ yellow ^ expected_yellow)) begin
                $display("PASS");
                $display("  Outputs: green=%b, red=%b, yellow=%b",
                         green, red, yellow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green=%b, red=%b, yellow=%b",
                         expected_green, expected_red, expected_yellow);
                $display("  Got:      green=%b, red=%b, yellow=%b",
                         green, red, yellow);
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
        $dumpvars(0,clk, rst, start, green, red, yellow);
    end

endmodule

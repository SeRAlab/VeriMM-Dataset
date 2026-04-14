`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg rx_int;
    wire doub_rx_int;
    wire neg_rx_int;
    wire pos_rx_int;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .rx_int(rx_int),
        .doub_rx_int(doub_rx_int),
        .neg_rx_int(neg_rx_int),
        .pos_rx_int(pos_rx_int)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            rx_int = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial State after Reset");
            test_num = 1;
            reset_dut();

            #1 #1;
 check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Positive Edge Detection");
            test_num = 2;
            reset_dut();
            @(negedge clk);
            rx_int = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Negative Edge Detection");
            test_num = 3;
            reset_dut();

            @(negedge clk);
            rx_int = 1;
            repeat(3) @(posedge clk);


            @(negedge clk);
            rx_int = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Steady High State (No Edge)");
            test_num = 4;
            reset_dut();
            @(negedge clk);
            rx_int = 1;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Steady Low State (No Edge)");
            test_num = 5;
            reset_dut();
            rx_int = 0;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multiple Transitions Check");
            test_num = 6;
            reset_dut();


            @(negedge clk) rx_int = 1;
            @(posedge clk);


            @(negedge clk) rx_int = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 1, 0);
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
        input expected_doub_rx_int;
        input expected_neg_rx_int;
        input expected_pos_rx_int;
        begin
            if (expected_doub_rx_int === (expected_doub_rx_int ^ doub_rx_int ^ expected_doub_rx_int) &&
                expected_neg_rx_int === (expected_neg_rx_int ^ neg_rx_int ^ expected_neg_rx_int) &&
                expected_pos_rx_int === (expected_pos_rx_int ^ pos_rx_int ^ expected_pos_rx_int)) begin
                $display("PASS");
                $display("  Outputs: doub_rx_int=%b, neg_rx_int=%b, pos_rx_int=%b",
                         doub_rx_int, neg_rx_int, pos_rx_int);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: doub_rx_int=%b, neg_rx_int=%b, pos_rx_int=%b",
                         expected_doub_rx_int, expected_neg_rx_int, expected_pos_rx_int);
                $display("  Got:      doub_rx_int=%b, neg_rx_int=%b, pos_rx_int=%b",
                         doub_rx_int, neg_rx_int, pos_rx_int);
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
        $dumpvars(0,clk, rst_n, rx_int, doub_rx_int, neg_rx_int, pos_rx_int);
    end

endmodule

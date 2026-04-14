`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk2_i;
    reg clk_i;
    reg data;
    reg data2_i;
    reg data_i;
    reg ready0;
    reg ready1;
    reg ready2_0;
    reg ready2_1;
    wire ready2_0_o;
    wire ready2_1_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk2_i(clk2_i),
        .clk_i(clk_i),
        .data(data),
        .data2_i(data2_i),
        .data_i(data_i),
        .ready0(ready0),
        .ready1(ready1),
        .ready2_0(ready2_0),
        .ready2_1(ready2_1),
        .ready2_0_o(ready2_0_o),
        .ready2_1_o(ready2_1_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ready0 = 0;
            ready1 = 0;
            ready2_0 = 0;
            ready2_1 = 0;
            data = 0;
            data2_i = 0;
            data_i = 0;

            repeat(10) @(posedge clk);
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            ready0 = 1;
            ready2_0 = 1;
            data = 1;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            ready1 = 1;
            ready2_1 = 1;
            data_i = 1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            ready0 = 1;
            ready2_0 = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            ready1 = 0;
            ready2_1 = 1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            ready0 = 1;
            ready2_0 = 1;
            ready1 = 1;
            ready2_1 = 1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clk);
            ready0 = 1;
            ready2_0 = 1;
            data = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(10) @(posedge clk);
            #1;

            check_outputs(0, 0);
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
        input expected_ready2_0_o;
        input expected_ready2_1_o;
        begin
            if (expected_ready2_0_o === (expected_ready2_0_o ^ ready2_0_o ^ expected_ready2_0_o) &&
                expected_ready2_1_o === (expected_ready2_1_o ^ ready2_1_o ^ expected_ready2_1_o)) begin
                $display("PASS");
                $display("  Outputs: ready2_0_o=%b, ready2_1_o=%b",
                         ready2_0_o, ready2_1_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready2_0_o=%b, ready2_1_o=%b",
                         expected_ready2_0_o, expected_ready2_1_o);
                $display("  Got:      ready2_0_o=%b, ready2_1_o=%b",
                         ready2_0_o, ready2_1_o);
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
        $dumpvars(0,clk, clk2_i, clk_i, data, data2_i, data_i, ready0, ready1, ready2_0, ready2_1, ready2_0_o, ready2_1_o);
    end

endmodule

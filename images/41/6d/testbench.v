`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg slowena;
    reg [3:0] threshold;
    wire [3:0] count;
    wire [3:0] final_output;
    wire high_if_count_greater_than_threshold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .slowena(slowena),
        .threshold(threshold),
        .count(count),
        .final_output(final_output),
        .high_if_count_greater_than_threshold(high_if_count_greater_than_threshold)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            slowena = 0;
            threshold = 4'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Count below threshold (Threshold=8, Count=5)", test_num);
            reset_dut();
            threshold = 4'd8;
            slowena = 1;
            repeat (5) @(posedge clk);
            #1;
            slowena = 0;

            #1;


            check_outputs(4'd5, 4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Count exceeding threshold (Threshold=8, Count=10)", test_num);
            reset_dut();
            threshold = 4'd8;
            slowena = 1;
            repeat (10) @(posedge clk);
            #1;
            slowena = 0;

            #1;


            check_outputs(4'd10, 4'd10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Count equals threshold (Threshold=4, Count=4)", test_num);
            reset_dut();
            threshold = 4'd4;
            slowena = 1;
            repeat (4) @(posedge clk);
            #1;
            slowena = 0;

            #1;


            check_outputs(4'd4, 4'd4, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Slow enable toggling (Threshold=2, Expected Count=3)", test_num);
            reset_dut();
            threshold = 4'd2;
            slowena = 1;
            repeat (2) @(posedge clk);
            #1 slowena = 0;
            repeat (5) @(posedge clk);
            #1 slowena = 1;
            repeat (1) @(posedge clk);
            #1;
            slowena = 0;

            #1;


            check_outputs(4'd3, 4'd3, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Counter wrap around (16+2=18 cycles, Threshold=5)", test_num);
            reset_dut();
            threshold = 4'd5;
            slowena = 1;
            repeat (18) @(posedge clk);
            #1;
            slowena = 0;


            #1;



            check_outputs(4'd2, 4'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Threshold at zero", test_num);
            reset_dut();
            threshold = 4'd0;
            slowena = 1;
            repeat (1) @(posedge clk);
            #1;
            slowena = 0;

            #1;


            check_outputs(4'd1, 4'd1, 1'b1);
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
        input [3:0] expected_count;
        input [3:0] expected_final_output;
        input expected_high_if_count_greater_than_threshold;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_high_if_count_greater_than_threshold === (expected_high_if_count_greater_than_threshold ^ high_if_count_greater_than_threshold ^ expected_high_if_count_greater_than_threshold)) begin
                $display("PASS");
                $display("  Outputs: count=%h, final_output=%h, high_if_count_greater_than_threshold=%b",
                         count, final_output, high_if_count_greater_than_threshold);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, final_output=%h, high_if_count_greater_than_threshold=%b",
                         expected_count, expected_final_output, expected_high_if_count_greater_than_threshold);
                $display("  Got:      count=%h, final_output=%h, high_if_count_greater_than_threshold=%b",
                         count, final_output, high_if_count_greater_than_threshold);
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
        $dumpvars(0,clk, reset, slowena, threshold, count, final_output, high_if_count_greater_than_threshold);
    end

endmodule

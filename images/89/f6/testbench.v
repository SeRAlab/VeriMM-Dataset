`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d_in;
    reg reset;
    wire d_out_1;
    wire d_out_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d_in(d_in),
        .reset(reset),
        .d_out_1(d_out_1),
        .d_out_2(d_out_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d_in = 0;
            #12;
            reset = 0;
            #8;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: d_in = 1 for one clock cycle", test_num);
            reset_dut();
            @(negedge clk);
            d_in = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: d_in = 0 for one clock cycle", test_num);
            reset_dut();
            @(negedge clk);
            d_in = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: d_in = 1 for two clock cycles", test_num);
            reset_dut();
            @(negedge clk);
            d_in = 1;
            @(posedge clk);
            @(negedge clk);
            d_in = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequence d_in = 1 then 0", test_num);
            reset_dut();
            @(negedge clk);
            d_in = 1;
            @(posedge clk);
            @(negedge clk);
            d_in = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Asynchronous reset during operation", test_num);
            reset_dut();
            @(negedge clk);
            d_in = 1;
            @(posedge clk);
            #2;
            reset = 1;
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
            reset = 0;
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
        input expected_d_out_1;
        input expected_d_out_2;
        begin
            if (expected_d_out_1 === (expected_d_out_1 ^ d_out_1 ^ expected_d_out_1) &&
                expected_d_out_2 === (expected_d_out_2 ^ d_out_2 ^ expected_d_out_2)) begin
                $display("PASS");
                $display("  Outputs: d_out_1=%b, d_out_2=%b",
                         d_out_1, d_out_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out_1=%b, d_out_2=%b",
                         expected_d_out_1, expected_d_out_2);
                $display("  Got:      d_out_1=%b, d_out_2=%b",
                         d_out_1, d_out_2);
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
        $dumpvars(0,clk, d_in, reset, d_out_1, d_out_2);
    end

endmodule

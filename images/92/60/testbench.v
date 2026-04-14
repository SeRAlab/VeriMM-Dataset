`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin_num;
    reg clk;
    wire [2:0] dec_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_num(bin_num),
        .clk(clk),
        .dec_num(dec_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            bin_num = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0 (Trigger)", test_num);
            reset_dut();
            bin_num = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 8 (Trigger)", test_num);
            reset_dut();
            bin_num = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 1 (Non-Trigger)", test_num);
            reset_dut();
            bin_num = 4'd1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 9 (Non-Trigger)", test_num);
            reset_dut();
            bin_num = 4'd9;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 12 (Non-Trigger)", test_num);
            reset_dut();
            bin_num = 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 7 (Non-Trigger)", test_num);
            reset_dut();
            bin_num = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
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
        input [2:0] expected_dec_num;
        begin
            if (expected_dec_num === (expected_dec_num ^ dec_num ^ expected_dec_num)) begin
                $display("PASS");
                $display("  Outputs: dec_num=%h",
                         dec_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec_num=%h",
                         expected_dec_num);
                $display("  Got:      dec_num=%h",
                         dec_num);
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
        $dumpvars(0,bin_num, clk, dec_num);
    end

endmodule

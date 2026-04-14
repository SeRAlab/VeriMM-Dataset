`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg loadseed_i;
    reg reset;
    reg [31:0] seed_i;
    wire [31:0] number_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .loadseed_i(loadseed_i),
        .reset(reset),
        .seed_i(seed_i),
        .number_o(number_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            loadseed_i = 0;
            seed_i = 32'h0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Reset Test", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Load Seed Test", test_num);
            reset_dut();
            loadseed_i = 1;
            seed_i = 32'hACE1B2C3;
            @(posedge clk);
            #1 loadseed_i = 0;

            #1;


            check_outputs(32'hACE1B2C3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Single Shift Test (Seed 0x1)", test_num);
            reset_dut();
            seed_i = 32'h00000001;
            loadseed_i = 1;
            @(posedge clk);
            #1 loadseed_i = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Multi-Shift XOR Logic Test", test_num);
            reset_dut();
            seed_i = 32'hFFFFFFFF;
            loadseed_i = 1;
            @(posedge clk);
            #1 loadseed_i = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hBFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Zero-State Stability Test", test_num);
            reset_dut();

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0);
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
        input [31:0] expected_number_o;
        begin
            if (expected_number_o === (expected_number_o ^ number_o ^ expected_number_o)) begin
                $display("PASS");
                $display("  Outputs: number_o=%h",
                         number_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: number_o=%h",
                         expected_number_o);
                $display("  Got:      number_o=%h",
                         number_o);
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
        $dumpvars(0,clk, loadseed_i, reset, seed_i, number_o);
    end

endmodule

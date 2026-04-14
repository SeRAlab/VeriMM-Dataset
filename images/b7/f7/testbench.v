`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] config_data;
    reg extClock_mode;
    reg rst;
    reg [31:0] sti_data;
    reg sti_valid;
    reg wrDivider;
    wire ready50;
    wire [31:0] sto_data;
    wire sto_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .config_data(config_data),
        .extClock_mode(extClock_mode),
        .rst(rst),
        .sti_data(sti_data),
        .sti_valid(sti_valid),
        .wrDivider(wrDivider),
        .ready50(ready50),
        .sto_data(sto_data),
        .sto_valid(sto_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            extClock_mode = 0;
            wrDivider = 0;
            config_data = 24'b0;
            sti_valid = 0;
            sti_data = 32'b0;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase 001: External Clock Mode Bypass");
            reset_dut();

            extClock_mode = 1;
            sti_data = 32'hDEADBEEF;
            sti_valid = 1;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(ready50, 32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase 002: Internal Mode Sampling (Div=4)");
            reset_dut();

            extClock_mode = 0;
            config_data = 24'd4;
            wrDivider = 1;
            @(posedge clk);
            wrDivider = 0;

            sti_data = 32'h12345678;
            sti_valid = 1;


            repeat(20) @(posedge clk);


            #1;



            check_outputs(ready50, 32'h12345678, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase 003: Internal Mode Timing Delay (Div=100)");
            reset_dut();

            extClock_mode = 0;
            config_data = 24'd100;
            wrDivider = 1;
            @(posedge clk);
            wrDivider = 0;

            sti_data = 32'hABCDEF01;
            sti_valid = 1;


            repeat(10) @(posedge clk);


            #1;



            check_outputs(ready50, 32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase 004: Internal Mode Data Capture");
            reset_dut();

            extClock_mode = 0;
            config_data = 24'd8;
            wrDivider = 1;
            @(posedge clk);
            wrDivider = 0;

            sti_data = 32'hAAAA_BBBB;
            sti_valid = 1;
            repeat(15) @(posedge clk);

            sti_data = 32'hCCCC_DDDD;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(ready50, 32'hAAAA_BBBB, 1'b1);
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
        input expected_ready50;
        input [31:0] expected_sto_data;
        input expected_sto_valid;
        begin
            if (expected_ready50 === (expected_ready50 ^ ready50 ^ expected_ready50) &&
                expected_sto_data === (expected_sto_data ^ sto_data ^ expected_sto_data) &&
                expected_sto_valid === (expected_sto_valid ^ sto_valid ^ expected_sto_valid)) begin
                $display("PASS");
                $display("  Outputs: ready50=%b, sto_data=%h, sto_valid=%b",
                         ready50, sto_data, sto_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready50=%b, sto_data=%h, sto_valid=%b",
                         expected_ready50, expected_sto_data, expected_sto_valid);
                $display("  Got:      ready50=%b, sto_data=%h, sto_valid=%b",
                         ready50, sto_data, sto_valid);
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
        $dumpvars(0,clk, config_data, extClock_mode, rst, sti_data, sti_valid, wrDivider, ready50, sto_data, sto_valid);
    end

endmodule

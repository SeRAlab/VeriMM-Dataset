`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg init_OPERATION;
    reg rst;
    wire enable_Pipeline_input;
    wire enable_input_internal;
    wire enable_shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .init_OPERATION(init_OPERATION),
        .rst(rst),
        .enable_Pipeline_input(enable_Pipeline_input),
        .enable_input_internal(enable_input_internal),
        .enable_shift_reg(enable_shift_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            init_OPERATION = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking Reset State");
            reset_dut();

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Initializing Operation");
            reset_dut();

            @(posedge clk);
            #1 init_OPERATION = 1;
            @(posedge clk);
            #1 init_OPERATION = 0;


            #1;



            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Checking Sequential Enable Logic");
            reset_dut();

            @(posedge clk);
            #1 init_OPERATION = 1;
            @(posedge clk);
            #1 init_OPERATION = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Reset Mid-Operation");
            reset_dut();

            @(posedge clk);
            #1 init_OPERATION = 1;
            repeat(2) @(posedge clk);


            #1 rst = 1;
            @(posedge clk);


            #1;



            check_outputs(0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Re-triggering Operation");
            reset_dut();


            @(posedge clk);
            #1 init_OPERATION = 1;
            @(posedge clk);
            #1 init_OPERATION = 0;
            repeat(5) @(posedge clk);


            @(posedge clk);
            #1 init_OPERATION = 1;
            @(posedge clk);
            #1 init_OPERATION = 0;


            #1;



            check_outputs(0, 1, 0);
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
        input expected_enable_Pipeline_input;
        input expected_enable_input_internal;
        input expected_enable_shift_reg;
        begin
            if (expected_enable_Pipeline_input === (expected_enable_Pipeline_input ^ enable_Pipeline_input ^ expected_enable_Pipeline_input) &&
                expected_enable_input_internal === (expected_enable_input_internal ^ enable_input_internal ^ expected_enable_input_internal) &&
                expected_enable_shift_reg === (expected_enable_shift_reg ^ enable_shift_reg ^ expected_enable_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: enable_Pipeline_input=%b, enable_input_internal=%b, enable_shift_reg=%b",
                         enable_Pipeline_input, enable_input_internal, enable_shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable_Pipeline_input=%b, enable_input_internal=%b, enable_shift_reg=%b",
                         expected_enable_Pipeline_input, expected_enable_input_internal, expected_enable_shift_reg);
                $display("  Got:      enable_Pipeline_input=%b, enable_input_internal=%b, enable_shift_reg=%b",
                         enable_Pipeline_input, enable_input_internal, enable_shift_reg);
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
        $dumpvars(0,clk, init_OPERATION, rst, enable_Pipeline_input, enable_input_internal, enable_shift_reg);
    end

endmodule

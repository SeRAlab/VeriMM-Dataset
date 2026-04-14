`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] counter_out;
    reg ena;
    reg load;
    reg [7:0] register_out;
    reg reset;
    reg select;
    wire [7:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .counter_out(counter_out),
        .ena(ena),
        .load(load),
        .register_out(register_out),
        .reset(reset),
        .select(select),
        .final_output(final_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ena = 0;
            load = 0;
            select = 0;
            counter_out = 4'h0;
            register_out = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Select=0 (Register Passthrough)");
            reset_dut();
            select = 0;
            register_out = 8'hA5;
            counter_out = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Select=1 (Bitwise OR Counter and Register)");
            reset_dut();
            select = 1;
            register_out = 8'h50;
            counter_out = 4'h0A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Bitwise OR with overlapping bits");
            reset_dut();
            select = 1;
            register_out = 8'hFF;
            counter_out = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: All zeros input");
            reset_dut();
            select = 1;
            register_out = 8'h00;
            counter_out = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Dynamic Select Switching");
            reset_dut();
            register_out = 8'hCC;
            counter_out = 4'h3;


            select = 0;
            @(posedge clk); #1;
            if (final_output !== 8'hCC) $display("Subtest Select 0 Failed");


            select = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(8'hCF);
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
        input [7:0] expected_final_output;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h",
                         final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h",
                         expected_final_output);
                $display("  Got:      final_output=%h",
                         final_output);
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
        $dumpvars(0,clk, counter_out, ena, load, register_out, reset, select, final_output);
    end

endmodule

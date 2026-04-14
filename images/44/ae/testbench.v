`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [7:0] exponent;
    reg load;
    wire [7:0] saved_exp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .exponent(exponent),
        .load(load),
        .saved_exp(saved_exp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            load = 0;
            exponent = 8'h00;
            @(posedge clk);
            #1;
            clear = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset check");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load 8'hA5");
            reset_dut();
            exponent = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Hold value");
            reset_dut();

            exponent = 8'h5A;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            exponent = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Clear priority over Load");
            reset_dut();

            exponent = 8'hAA;
            load = 1;
            @(posedge clk);
            #1;

            clear = 1;
            load = 1;
            exponent = 8'hBB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple Loads");
            reset_dut();
            load = 1;
            exponent = 8'h11;
            @(posedge clk);
            #1;
            exponent = 8'h22;
            @(posedge clk);
            #1;
            exponent = 8'h33;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Load 8'hFF");
            reset_dut();
            exponent = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_saved_exp;
        begin
            if (expected_saved_exp === (expected_saved_exp ^ saved_exp ^ expected_saved_exp)) begin
                $display("PASS");
                $display("  Outputs: saved_exp=%h",
                         saved_exp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saved_exp=%h",
                         expected_saved_exp);
                $display("  Got:      saved_exp=%h",
                         saved_exp);
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
        $dumpvars(0,clear, clk, exponent, load, saved_exp);
    end

endmodule

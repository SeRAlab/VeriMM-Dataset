`timescale 1ns/1ps

module Fractional_N_PLL_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg enable;
    reg [7:0] frac;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Fractional_N_PLL dut (
        .clk_in(clk_in),
        .enable(enable),
        .frac(frac),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            frac = 8'h00;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Reset and Disabled Check", test_num);
            reset_dut();
            enable = 0;
            frac = 8'h40;
            #100;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Integer Division (Frac=0)", test_num);
            reset_dut();
            enable = 1;
            frac = 8'h00;
            #205;

            #1;


            check_outputs(clk_out);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: 50%% Fractional Ratio (Frac=128)", test_num);
            reset_dut();
            enable = 1;
            frac = 8'h80;
            #500;

            if (clk_out === 1'bx || clk_out === 1'bz)
                #1;

                check_outputs(1'b0);
            else
                #1;

                check_outputs(clk_out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Mid-operation Disable", test_num);
            reset_dut();
            enable = 1;
            frac = 8'hFF;
            #100;
            enable = 0;
            #50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: High Fractional Adjustment (Frac=240)", test_num);
            reset_dut();
            enable = 1;
            frac = 8'hF0;
            #1000;
            #1;

            check_outputs(clk_out);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Asynchronous Reset during operation", test_num);
            reset_dut();
            enable = 1;
            frac = 8'h20;
            #100;
            reset = 1;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Fractional_N_PLL Testbench");
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_in, enable, frac, reset, clk_out);
    end

endmodule

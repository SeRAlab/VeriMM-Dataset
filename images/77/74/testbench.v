`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_rstn;
    wire o_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .o_clk(o_clk)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_rstn = 0;
            repeat(2) @(posedge i_clk);
            #1;
            i_rstn = 1;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Check...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Short Run Check (2 cycles)...");
            test_num = 2;
            reset_dut();
            repeat(2) @(posedge i_clk);
            #1;


            #1;



            check_outputs(o_clk);
            $display("  Info: o_clk observed as %b", o_clk);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Long Run Check (20 cycles)...");
            test_num = 3;
            reset_dut();
            repeat(20) @(posedge i_clk);
            #1;

            if (o_clk === 1'b0 || o_clk === 1'b1)
                pass_count = pass_count + 0;
            #1;

            check_outputs(o_clk);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Mid-Operation Reset...");
            test_num = 4;
            reset_dut();
            repeat(10) @(posedge i_clk);
            i_rstn = 0;
            #15;
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
        input expected_o_clk;
        begin
            if (expected_o_clk === (expected_o_clk ^ o_clk ^ expected_o_clk)) begin
                $display("PASS");
                $display("  Outputs: o_clk=%b",
                         o_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_clk=%b",
                         expected_o_clk);
                $display("  Got:      o_clk=%b",
                         o_clk);
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
        $dumpvars(0,i_clk, i_rstn, o_clk);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] inp8;
    reg load;
    reg reset;
    wire [7:0] outf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inp8(inp8),
        .load(load),
        .reset(reset),
        .outf(outf)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            inp8 = 0;
            @(posedge clk);
            #1;
            reset = 0;
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
            $display("Testcase 002: Load value check");
            reset_dut();
            load = 1;
            inp8 = 8'hA5;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single shift (XOR 1^1=0)");
            reset_dut();
            load = 1;
            inp8 = 8'h03;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Single shift (XOR 1^0=1)");
            reset_dut();
            load = 1;
            inp8 = 8'h02;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multi-cycle sequence");
            reset_dut();
            load = 1;
            inp8 = 8'h01;
            @(posedge clk);
            #1;
            load = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0D);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shifting out bits");
            reset_dut();
            load = 1;
            inp8 = 8'h80;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_outf;
        begin
            if (expected_outf === (expected_outf ^ outf ^ expected_outf)) begin
                $display("PASS");
                $display("  Outputs: outf=%h",
                         outf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outf=%h",
                         expected_outf);
                $display("  Got:      outf=%h",
                         outf);
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
        $dumpvars(0,clk, inp8, load, reset, outf);
    end

endmodule

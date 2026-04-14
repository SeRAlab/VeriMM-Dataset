`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg en;
    reg ld;
    reg rst_n;
    wire [15:0] r0_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .en(en),
        .ld(ld),
        .rst_n(rst_n),
        .r0_out(r0_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            en = 0;
            ld = 0;
            data = 8'h00;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset State");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Normal Decimation Cycle");
            reset_dut();
            en = 1;
            ld = 1;

            data = 8'hAB; @(posedge clk); #1;
            data = 8'hCD; @(posedge clk); #1;
            data = 8'h00; ld = 0;


            #1;



            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Enable Control");
            reset_dut();
            en = 0;
            ld = 1;
            data = 8'hFF;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Load Control");
            reset_dut();
            en = 1;
            ld = 0;
            data = 8'hFF;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Multiple Cycles");
            reset_dut();
            en = 1;
            ld = 1;


            data = 8'h12; @(posedge clk); #1;
            data = 8'h34; @(posedge clk); #1;


            data = 8'h56; @(posedge clk); #1;
            data = 8'h78; @(posedge clk); #1;

            ld = 0;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Interrupted Load");
            reset_dut();
            en = 1;
            ld = 1;
            data = 8'hA1; @(posedge clk); #1;

            ld = 0;       data = 8'hB2; @(posedge clk); #1;
            ld = 1;       data = 8'hC3; @(posedge clk); #1;



            #1;




            check_outputs(16'hA1C3);
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
        input [15:0] expected_r0_out;
        begin
            if (expected_r0_out === (expected_r0_out ^ r0_out ^ expected_r0_out)) begin
                $display("PASS");
                $display("  Outputs: r0_out=%h",
                         r0_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r0_out=%h",
                         expected_r0_out);
                $display("  Got:      r0_out=%h",
                         r0_out);
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
        $dumpvars(0,clk, data, en, ld, rst_n, r0_out);
    end

endmodule

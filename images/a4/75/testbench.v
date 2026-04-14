`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] slt0;
    reg [19:0] slt1;
    reg [19:0] slt2;
    reg [19:0] slt3;
    reg [19:0] slt4;
    reg [19:0] slt6;
    reg [19:0] slt7;
    reg [19:0] slt8;
    reg [19:0] slt9;
    reg so_ld;
    wire sdata_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .slt0(slt0),
        .slt1(slt1),
        .slt2(slt2),
        .slt3(slt3),
        .slt4(slt4),
        .slt6(slt6),
        .slt7(slt7),
        .slt8(slt8),
        .slt9(slt9),
        .so_ld(so_ld),
        .sdata_out(sdata_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            so_ld = 0;
            slt0 = 0; slt1 = 0; slt2 = 0; slt3 = 0; slt4 = 0;
            slt6 = 0; slt7 = 0; slt8 = 0; slt9 = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase 001: Slot 0 MSB...");
            reset_dut();
            slt0 = 16'h8000;
            so_ld = 1;
            @(posedge clk);
            #1;
            so_ld = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase 002: Slot 0 LSB...");
            reset_dut();
            slt0 = 16'h0001;
            so_ld = 1;
            @(posedge clk);
            so_ld = 0;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase 003: Slot 1 MSB...");
            reset_dut();
            slt1 = 20'h80000;
            so_ld = 1;
            @(posedge clk);
            so_ld = 0;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase 004: Slot 4 LSB...");
            reset_dut();
            slt4 = 20'h00001;
            so_ld = 1;
            @(posedge clk);
            so_ld = 0;
            repeat(95) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase 005: Slot 9 LSB...");
            reset_dut();
            slt9 = 20'h00001;
            so_ld = 1;
            @(posedge clk);
            so_ld = 0;
            repeat(195) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_sdata_out;
        begin
            if (expected_sdata_out === (expected_sdata_out ^ sdata_out ^ expected_sdata_out)) begin
                $display("PASS");
                $display("  Outputs: sdata_out=%b",
                         sdata_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sdata_out=%b",
                         expected_sdata_out);
                $display("  Got:      sdata_out=%b",
                         sdata_out);
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
        $dumpvars(0,clk, rst, slt0, slt1, slt2, slt3, slt4, slt6, slt7, slt8, slt9, so_ld, sdata_out);
    end

endmodule

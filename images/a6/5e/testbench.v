`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg [2:0] dr;
    reg ld_reg;
    reg rst;
    reg [2:0] sr1;
    reg [2:0] sr2;
    wire sr1_out;
    wire sr2_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .dr(dr),
        .ld_reg(ld_reg),
        .rst(rst),
        .sr1(sr1),
        .sr2(sr2),
        .sr1_out(sr1_out),
        .sr2_out(sr2_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ld_reg = 0;
            data = 0;
            dr = 0;
            sr1 = 0;
            sr2 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();
            sr1 = 3;
            sr2 = 7;
            #1 #1;
 check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();
            data = 16'hABCD;
            dr = 2;
            ld_reg = 1;
            @(posedge clk);
            #1 ld_reg = 0;
            sr1 = 2;
            sr2 = 0;
            #1 #1;
 check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multiple Register Storage", test_num);
            reset_dut();

            data = 16'h1234; dr = 1; ld_reg = 1; @(posedge clk);

            data = 16'h5678; dr = 5; ld_reg = 1; @(posedge clk);
            #1 ld_reg = 0;
            sr1 = 1;
            sr2 = 5;
            #1 #1;
 check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: ld_reg Gating Check", test_num);
            reset_dut();
            data = 16'hFFFF;
            dr = 4;
            ld_reg = 0;
            @(posedge clk);
            #1 sr1 = 4;
            sr2 = 4;
            #1 #1;
 check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Overwriting Data", test_num);
            reset_dut();
            data = 16'hAAAA; dr = 6; ld_reg = 1; @(posedge clk);
            data = 16'h5555; dr = 6; ld_reg = 1; @(posedge clk);
            #1 ld_reg = 0;
            sr1 = 6;
            sr2 = 6;
            #1 #1;
 check_outputs(16'h5555, 16'h5555);
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
        input expected_sr1_out;
        input expected_sr2_out;
        begin
            if (expected_sr1_out === (expected_sr1_out ^ sr1_out ^ expected_sr1_out) &&
                expected_sr2_out === (expected_sr2_out ^ sr2_out ^ expected_sr2_out)) begin
                $display("PASS");
                $display("  Outputs: sr1_out=%b, sr2_out=%b",
                         sr1_out, sr2_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sr1_out=%b, sr2_out=%b",
                         expected_sr1_out, expected_sr2_out);
                $display("  Got:      sr1_out=%b, sr2_out=%b",
                         sr1_out, sr2_out);
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
        $dumpvars(0,clk, data, dr, ld_reg, rst, sr1, sr2, sr1_out, sr2_out);
    end

endmodule

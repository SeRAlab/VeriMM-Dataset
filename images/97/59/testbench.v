`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [159:0] values;
    wire [31:0] rows;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .values(values),
        .rows(rows)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            values = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: All values 1, check n=0");
            values = {32{5'd1}};
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: All values 1, check n=1");
            values = {32{5'd1}};
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case 003: Incremental values, check n=2");
            for(i=0; i<32; i=i+1) values[i*5 +: 5] = i;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFF8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Values 15, check n=14");
            values = {32{5'd15}};
            reset_dut();
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Values 15, check n=15");
            values = {32{5'd15}};
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Wrap-around check (n=0 again)");
            values = {32{5'd1}};
            reset_dut();
            repeat(33) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_rows;
        begin
            if (expected_rows === (expected_rows ^ rows ^ expected_rows)) begin
                $display("PASS");
                $display("  Outputs: rows=%h",
                         rows);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rows=%h",
                         expected_rows);
                $display("  Got:      rows=%h",
                         rows);
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
        $dumpvars(0,clk, rst_n, values, rows);
    end

endmodule

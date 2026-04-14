`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd_en;
    reg rst_n;
    reg wr_en;
    wire reg_en;
    wire reg_wr_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_en(rd_en),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .reg_en(reg_en),
        .reg_wr_en(reg_wr_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rd_en = 0;
            wr_en = 0;
            rst_n = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Reset state check");

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Write enable debounce check");

            @(posedge clk);
            wr_en <= 1'b1;
            rd_en <= 1'b0;


            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Read enable debounce check");

            @(posedge clk);
            wr_en <= 1'b0;
            rd_en <= 1'b1;


            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Simultaneous RD and WR check");

            @(posedge clk);
            wr_en <= 1'b1;
            rd_en <= 1'b1;

            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: De-assertion check");


            @(posedge clk);
            wr_en <= 1'b1;
            repeat(4) @(posedge clk);


            @(posedge clk);
            wr_en <= 1'b0;
            rd_en <= 1'b0;


            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(1'b0, 1'b0);
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
        input expected_reg_en;
        input expected_reg_wr_en;
        begin
            if (expected_reg_en === (expected_reg_en ^ reg_en ^ expected_reg_en) &&
                expected_reg_wr_en === (expected_reg_wr_en ^ reg_wr_en ^ expected_reg_wr_en)) begin
                $display("PASS");
                $display("  Outputs: reg_en=%b, reg_wr_en=%b",
                         reg_en, reg_wr_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_en=%b, reg_wr_en=%b",
                         expected_reg_en, expected_reg_wr_en);
                $display("  Got:      reg_en=%b, reg_wr_en=%b",
                         reg_en, reg_wr_en);
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
        $dumpvars(0,clk, rd_en, rst_n, wr_en, reg_en, reg_wr_en);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] wq2_rptr;
    reg wr_clk;
    reg wr_en;
    reg wr_rst;
    wire full;
    wire [2:0] wr_addr;
    wire [3:0] wr_ptr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wq2_rptr(wq2_rptr),
        .wr_clk(wr_clk),
        .wr_en(wr_en),
        .wr_rst(wr_rst),
        .full(full),
        .wr_addr(wr_addr),
        .wr_ptr(wr_ptr)
    );

    // Clock generation (10ns period)
    initial begin
        wr_clk = 0;
        forever #5 wr_clk = ~wr_clk;
    end

        task reset_dut;

        begin
            wr_rst = 1;
            wr_en = 0;
            wq2_rptr = 4'b0000;
            @(posedge wr_clk);
            #1;
            wr_rst = 0;
            @(posedge wr_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(0, 3'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write Operation");
            reset_dut();
            wr_en = 1;
            @(posedge wr_clk);
            #1;
            wr_en = 0;

            #1;


            check_outputs(0, 3'h1, 4'h1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiple Writes (4 items)");
            reset_dut();
            wr_en = 1;
            repeat(4) @(posedge wr_clk);
            #1;
            wr_en = 0;


            #1;



            check_outputs(0, 3'h4, 4'h6);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Fill to Full Condition");
            reset_dut();
            wq2_rptr = 4'b0000;
            wr_en = 1;

            repeat(8) @(posedge wr_clk);
            #1;
            wr_en = 0;


            #1;



            check_outputs(1, 3'h0, 4'hc);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Write Attempt While Full");
            reset_dut();
            wq2_rptr = 4'b0000;
            wr_en = 1;
            repeat(10) @(posedge wr_clk);
            #1;
            wr_en = 0;

            #1;


            check_outputs(1, 3'h0, 4'hc);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Clear Full by Moving Read Pointer");
            reset_dut();
            wq2_rptr = 4'b0000;
            wr_en = 1;
            repeat(8) @(posedge wr_clk);
            #1;
            wr_en = 0;

            wq2_rptr = 4'b0001;
            #1;

            #1;


            check_outputs(0, 3'h0, 4'hc);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Wraparound of 4-bit Pointer");
            reset_dut();

            wq2_rptr = 4'b1000;
            wr_en = 1;
            repeat(15) @(posedge wr_clk);
            #1;
            wr_en = 0;

            #1;


            check_outputs(0, 3'h7, 4'h8);


            wr_en = 1;
            @(posedge wr_clk);
            #1;
            wr_en = 0;
            #1;

            check_outputs(0, 3'h0, 4'h0);
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
        testcase007();
        
        
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
        input expected_full;
        input [2:0] expected_wr_addr;
        input [3:0] expected_wr_ptr;
        begin
            if (expected_full === (expected_full ^ full ^ expected_full) &&
                expected_wr_addr === (expected_wr_addr ^ wr_addr ^ expected_wr_addr) &&
                expected_wr_ptr === (expected_wr_ptr ^ wr_ptr ^ expected_wr_ptr)) begin
                $display("PASS");
                $display("  Outputs: full=%b, wr_addr=%h, wr_ptr=%h",
                         full, wr_addr, wr_ptr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: full=%b, wr_addr=%h, wr_ptr=%h",
                         expected_full, expected_wr_addr, expected_wr_ptr);
                $display("  Got:      full=%b, wr_addr=%h, wr_ptr=%h",
                         full, wr_addr, wr_ptr);
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
        $dumpvars(0,wq2_rptr, wr_clk, wr_en, wr_rst, full, wr_addr, wr_ptr);
    end

endmodule

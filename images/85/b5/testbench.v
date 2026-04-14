`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg ce;
    reg clk;
    reg [31:0] di;
    reg [3:0] we;
    wire [31:0] doq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .ce(ce),
        .clk(clk),
        .di(di),
        .we(we),
        .doq(doq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            we = 4'b0;
            addr = 10'b0;
            di = 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Word Write and Read");


            ce = 1; we = 4'hf; addr = 10'h010; di = 32'hDEADBEEF;
            @(posedge clk); #1;


            we = 4'h0; addr = 10'h010;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Selective Byte Writing (Masking)");


            ce = 1; we = 4'hf; addr = 10'h020; di = 32'h00000000;
            @(posedge clk); #1;



            ce = 1; we = 4'hA; addr = 10'h020; di = 32'hAA11BB22;
            @(posedge clk); #1;


            we = 4'h0; addr = 10'h020;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(32'hAA00BB00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Chip Enable (CE) Inhibit Test");


            ce = 1; we = 4'hf; addr = 10'h030; di = 32'h12345678;
            @(posedge clk); #1;


            ce = 0; we = 4'hf; addr = 10'h030; di = 32'hFFFFFFFF;
            @(posedge clk); #1;


            ce = 1; we = 4'h0; addr = 10'h030;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Multi-cycle Port Access");

            addr = 10'h040; ce = 1;
            di = 32'h11223344;

            we = 4'b1000; @(posedge clk); #1;
            we = 4'b0100; @(posedge clk); #1;
            we = 4'b0010; @(posedge clk); #1;
            we = 4'b0001; @(posedge clk); #1;

            we = 4'h0; addr = 10'h040;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h11223344);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Address Boundary Test (1023)");

            ce = 1; we = 4'hf; addr = 10'd1023; di = 32'hA5A5A5A5;
            @(posedge clk); #1;

            we = 4'h0; addr = 10'd1023;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(32'hA5A5A5A5);
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
        input [31:0] expected_doq;
        begin
            if (expected_doq === (expected_doq ^ doq ^ expected_doq)) begin
                $display("PASS");
                $display("  Outputs: doq=%h",
                         doq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: doq=%h",
                         expected_doq);
                $display("  Got:      doq=%h",
                         doq);
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
        $dumpvars(0,addr, ce, clk, di, we, doq);
    end

endmodule

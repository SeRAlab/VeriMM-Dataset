`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg re;
    reg rst;
    reg [15:0] wdata;
    reg we;
    wire [15:0] rdata;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .re(re),
        .rst(rst),
        .wdata(wdata),
        .we(we),
        .rdata(rdata),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            we = 0;
            re = 0;
            addr = 0;
            wdata = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset Check");
            reset_dut();

            addr = 16'h0000;
            re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write and Read Address 0");
            reset_dut();

            addr = 16'h0000;
            wdata = 16'hAAAA;
            we = 1;
            @(posedge clk);
            #1 we = 0;

            re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write and Read Address 1");
            reset_dut();

            addr = 16'h0001;
            wdata = 16'h5555;
            we = 1;
            @(posedge clk);
            #1 we = 0;

            re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h5555, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Independence Check (Write 0 and 1, Read 0)");
            reset_dut();

            addr = 16'h0000; wdata = 16'h1234; we = 1;
            @(posedge clk);

            addr = 16'h0001; wdata = 16'h5678; we = 1;
            @(posedge clk);
            #1 we = 0;

            addr = 16'h0000; re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwrite Address 1");
            reset_dut();

            addr = 16'h0001; wdata = 16'h1111; we = 1;
            @(posedge clk);

            wdata = 16'h2222; we = 1;
            @(posedge clk);
            #1 we = 0;

            re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h2222, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Write Enable inactive check");
            reset_dut();

            addr = 16'h0000; wdata = 16'hDEAD; we = 1;
            @(posedge clk);

            wdata = 16'hBEEF; we = 0;
            @(posedge clk);

            re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hDEAD, 1'b1);
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
        input [15:0] expected_rdata;
        input expected_ready;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h, ready=%b",
                         rdata, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h, ready=%b",
                         expected_rdata, expected_ready);
                $display("  Got:      rdata=%h, ready=%b",
                         rdata, ready);
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
        $dumpvars(0,addr, clk, re, rst, wdata, we, rdata, ready);
    end

endmodule

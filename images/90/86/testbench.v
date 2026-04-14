`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] raddr1;
    reg [4:0] raddr2;
    reg re1;
    reg re2;
    reg rst;
    reg [4:0] waddr;
    reg [31:0] wdata;
    reg we;
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .re1(re1),
        .re2(re2),
        .rst(rst),
        .waddr(waddr),
        .wdata(wdata),
        .we(we),
        .rdata1(rdata1),
        .rdata2(rdata2)
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
        re1 = 0;
        re2 = 0;
        waddr = 0;
        wdata = 0;
        raddr1 = 0;
        raddr2 = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset and R0 check...");
        reset_dut();


        re1 = 1; raddr1 = 0;
        re2 = 1; raddr2 = 5;
        #1;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Simple Write and Readback...");
        reset_dut();


        @(posedge clk);
        we = 1; waddr = 5'd1; wdata = 32'hDEADBEEF;
        @(posedge clk);
        we = 0;


        re1 = 1; raddr1 = 5'd1;
        re2 = 0; raddr2 = 0;
        #1;
        #1;

        check_outputs(32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Simultaneous Dual Read...");
        reset_dut();


        @(posedge clk);
        we = 1; waddr = 5'd10; wdata = 32'h12345678;
        @(posedge clk);

        we = 1; waddr = 5'd20; wdata = 32'h87654321;
        @(posedge clk);
        we = 0;


        re1 = 1; raddr1 = 5'd10;
        re2 = 1; raddr2 = 5'd20;
        #1;
        #1;

        check_outputs(32'h12345678, 32'h87654321);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Read Enable Logic...");
        reset_dut();


        @(posedge clk);
        we = 1; waddr = 5'd2; wdata = 32'hAAAA_5555;
        @(posedge clk);
        we = 0;


        re1 = 0; raddr1 = 5'd2;
        re2 = 1; raddr2 = 5'd2;
        #1;
        #1;

        check_outputs(32'h0, 32'hAAAA_5555);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Register 0 Write-Ignore...");
        reset_dut();


        @(posedge clk);
        we = 1; waddr = 5'd0; wdata = 32'hFFFF_FFFF;
        @(posedge clk);
        we = 0;


        re1 = 1; raddr1 = 5'd0;
        re2 = 0; raddr2 = 0;
        #1;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Reset priority check...");
        reset_dut();


        @(posedge clk);
        we = 1; waddr = 5'd15; wdata = 32'hCAFE_BABE;
        @(posedge clk);
        we = 0;


        re1 = 1; raddr1 = 5'd15;
        #1;

        rst = 1;
        #1;
        #1;

        check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_rdata1;
        input [31:0] expected_rdata2;
        begin
            if (expected_rdata1 === (expected_rdata1 ^ rdata1 ^ expected_rdata1) &&
                expected_rdata2 === (expected_rdata2 ^ rdata2 ^ expected_rdata2)) begin
                $display("PASS");
                $display("  Outputs: rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata1=%h, rdata2=%h",
                         expected_rdata1, expected_rdata2);
                $display("  Got:      rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
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
        $dumpvars(0,clk, raddr1, raddr2, re1, re2, rst, waddr, wdata, we, rdata1, rdata2);
    end

endmodule

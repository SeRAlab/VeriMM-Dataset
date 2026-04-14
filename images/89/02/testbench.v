`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] raddr1;
    reg [3:0] raddr2;
    reg rst;
    reg [3:0] waddr;
    reg [15:0] wdata;
    reg wen;
    wire [15:0] rdata1;
    wire [15:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .rst(rst),
        .waddr(waddr),
        .wdata(wdata),
        .wen(wen),
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
            wen = 0;
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
            test_num = 1;
            $display("Testcase 001: Reset Check");
            reset_dut();
            raddr1 = 4'h3;
            raddr2 = 4'hF;
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single Write/Read");
            reset_dut();
            @(posedge clk);
            wen = 1;
            waddr = 4'h5;
            wdata = 16'hABCD;
            @(posedge clk);
            wen = 0;
            raddr1 = 4'h5;
            raddr2 = 4'h5;
            #1;
            #1;

            check_outputs(16'hABCD, 16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Write Enable Check");
            reset_dut();
            @(posedge clk);
            wen = 0;
            waddr = 4'hA;
            wdata = 16'h5555;
            @(posedge clk);
            raddr1 = 4'hA;
            raddr2 = 4'h0;
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Dual Port Reading");
            reset_dut();

            @(posedge clk);
            wen = 1; waddr = 4'h1; wdata = 16'h1111;

            @(posedge clk);
            wen = 1; waddr = 4'h2; wdata = 16'h2222;
            @(posedge clk);
            wen = 0;
            raddr1 = 4'h1;
            raddr2 = 4'h2;
            #1;
            #1;

            check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Overwrite Register");
            reset_dut();
            @(posedge clk);
            wen = 1; waddr = 4'h8; wdata = 16'hAAAA;
            @(posedge clk);
            wen = 1; waddr = 4'h8; wdata = 16'hBBBB;
            @(posedge clk);
            wen = 0;
            raddr1 = 4'h8;
            raddr2 = 4'h0;
            #1;
            #1;

            check_outputs(16'hBBBB, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: High Address Check (0xF)");
            reset_dut();
            @(posedge clk);
            wen = 1; waddr = 4'hF; wdata = 16'hFFFF;
            @(posedge clk);
            wen = 0;
            raddr1 = 4'hF;
            raddr2 = 4'h0;
            #1;
            #1;

            check_outputs(16'hFFFF, 16'h0000);
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
        input [15:0] expected_rdata1;
        input [15:0] expected_rdata2;
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
        $dumpvars(0,clk, raddr1, raddr2, rst, waddr, wdata, wen, rdata1, rdata2);
    end

endmodule

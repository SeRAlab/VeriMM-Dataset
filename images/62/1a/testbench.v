`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a_addr;
    reg a_clk;
    reg [7:0] a_wdata;
    reg a_wen;
    reg [7:0] b_addr;
    reg b_clk;
    reg [7:0] b_wdata;
    reg b_wen;
    wire [7:0] a_rdata;
    wire [7:0] b_rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_addr(a_addr),
        .a_clk(a_clk),
        .a_wdata(a_wdata),
        .a_wen(a_wen),
        .b_addr(b_addr),
        .b_clk(b_clk),
        .b_wdata(b_wdata),
        .b_wen(b_wen),
        .a_rdata(a_rdata),
        .b_rdata(b_rdata)
    );

    // Clock generation (10ns period)
    initial begin
        a_clk = 0;
        forever #5 a_clk = ~a_clk;
    end

        task reset_dut;

    begin
        a_addr = 8'h0;
        a_wdata = 8'h0;
        a_wen = 1'b0;
        b_addr = 8'h0;
        b_wdata = 8'h0;
        b_wen = 1'b0;
        repeat(2) @(posedge a_clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Running testcase001: Basic Independent Read/Write...");


        @(posedge a_clk);
        a_addr = 8'h10; a_wdata = 8'hAA; a_wen = 1;
        b_addr = 8'h20; b_wdata = 8'h55; b_wen = 1;

        @(posedge a_clk);
        a_wen = 0;
        b_wen = 0;


        @(posedge a_clk);
        a_addr = 8'h10;
        b_addr = 8'h20;


        repeat(2) @(posedge a_clk);
        #1;
        #1;

        check_outputs(8'hAA, 8'h55);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Running testcase002: Cross-Port Access (A Write, B Read)...");


        @(posedge a_clk);
        a_addr = 8'h30; a_wdata = 8'hDE; a_wen = 1;

        @(posedge a_clk);
        a_wen = 0;


        @(posedge b_clk);
        b_addr = 8'h30;


        a_addr = 8'h40; a_wdata = 8'h11; a_wen = 1;
        @(posedge a_clk);
        a_wen = 0;
        a_addr = 8'h40;

        repeat(2) @(posedge a_clk);
        #1;
        #1;

        check_outputs(8'h11, 8'hDE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Running testcase003: Cross-Port Access (B Write, A Read)...");


        @(posedge b_clk);
        b_addr = 8'h50; b_wdata = 8'hBC; b_wen = 1;

        @(posedge b_clk);
        b_wen = 0;


        @(posedge a_clk);
        a_addr = 8'h50;


        b_addr = 8'h01; b_wdata = 8'h01; b_wen = 1;
        @(posedge b_clk);
        b_wen = 0;
        b_addr = 8'h01;

        repeat(2) @(posedge a_clk);
        #1;
        #1;

        check_outputs(8'hBC, 8'h01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Running testcase004: Write Enable (wen) Check...");


        @(posedge a_clk);
        a_addr = 8'h60; a_wdata = 8'h77; a_wen = 1;
        @(posedge a_clk);


        a_wdata = 8'hFF; a_wen = 0;
        @(posedge a_clk);


        a_addr = 8'h60;
        b_addr = 8'h00;

        repeat(2) @(posedge a_clk);
        #1;
        #1;

        check_outputs(8'h77, b_rdata);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Running testcase005: Simultaneous Reads from same address...");


        @(posedge a_clk);
        a_addr = 8'h88; a_wdata = 8'h99; a_wen = 1;
        @(posedge a_clk);
        a_wen = 0;


        @(posedge a_clk);
        a_addr = 8'h88;
        b_addr = 8'h88;

        repeat(2) @(posedge a_clk);
        #1;
        #1;

        check_outputs(8'h99, 8'h99);
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
        input [7:0] expected_a_rdata;
        input [7:0] expected_b_rdata;
        begin
            if (expected_a_rdata === (expected_a_rdata ^ a_rdata ^ expected_a_rdata) &&
                expected_b_rdata === (expected_b_rdata ^ b_rdata ^ expected_b_rdata)) begin
                $display("PASS");
                $display("  Outputs: a_rdata=%h, b_rdata=%h",
                         a_rdata, b_rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_rdata=%h, b_rdata=%h",
                         expected_a_rdata, expected_b_rdata);
                $display("  Got:      a_rdata=%h, b_rdata=%h",
                         a_rdata, b_rdata);
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
        $dumpvars(0,a_addr, a_clk, a_wdata, a_wen, b_addr, b_clk, b_wdata, b_wen, a_rdata, b_rdata);
    end

endmodule

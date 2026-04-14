`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] daddr;
    reg de;
    reg [31:0] din;
    reg [1:0] drw;
    reg [31:0] iaddr;
    reg ie;
    reg pmc_cache_access_D;
    reg pmc_cache_access_I;
    reg pmc_cache_miss_D;
    reg pmc_cache_miss_I;
    reg pmc_int;
    reg pmc_uart_recv;
    reg pmc_uart_send;
    reg rst;
    wire [31:0] dout;
    wire [31:0] iout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .daddr(daddr),
        .de(de),
        .din(din),
        .drw(drw),
        .iaddr(iaddr),
        .ie(ie),
        .pmc_cache_access_D(pmc_cache_access_D),
        .pmc_cache_access_I(pmc_cache_access_I),
        .pmc_cache_miss_D(pmc_cache_miss_D),
        .pmc_cache_miss_I(pmc_cache_miss_I),
        .pmc_int(pmc_int),
        .pmc_uart_recv(pmc_uart_recv),
        .pmc_uart_send(pmc_uart_send),
        .rst(rst),
        .dout(dout),
        .iout(iout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        de = 0;
        ie = 0;
        drw = 2'b00;
        din = 0;
        daddr = 0;
        iaddr = 0;
        pmc_int = 0;
        pmc_cache_miss_I = 0;
        pmc_cache_miss_D = 0;
        pmc_cache_access_I = 0;
        pmc_cache_access_D = 0;
        pmc_uart_recv = 0;
        pmc_uart_send = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Checking if counters are zero after reset.");
        reset_dut();


        daddr = ADDR_INT;
        iaddr = ADDR_INT;
        de = 1;
        ie = 1;
        drw = 2'b01;
        #10;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Testing Interrupt Counter increment (3 events).");
        reset_dut();


        repeat(3) begin
            @(negedge clk);
            pmc_int = 1;
            @(posedge clk);
            #1 pmc_int = 0;
        end


        daddr = ADDR_INT;
        iaddr = ADDR_INT;
        de = 1;
        ie = 1;
        drw = 2'b01;
        #10;
        #1;

        check_outputs(32'h3, 32'h3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Testing I-Cache Misses and Accesses.");
        reset_dut();


        repeat(5) begin
            @(negedge clk);
            pmc_cache_access_I = 1;
            @(posedge clk);
            #1 pmc_cache_access_I = 0;
        end
        repeat(2) begin
            @(negedge clk);
            pmc_cache_miss_I = 1;
            @(posedge clk);
            #1 pmc_cache_miss_I = 0;
        end


        daddr = ADDR_ACC_I;
        iaddr = ADDR_MISS_I;
        de = 1;
        ie = 1;
        drw = 2'b01;
        #10;
        #1;

        check_outputs(32'h5, 32'h2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Testing D-Cache Misses and Accesses.");
        reset_dut();


        repeat(10) begin
            @(negedge clk);
            pmc_cache_access_D = 1;
            @(posedge clk);
            #1 pmc_cache_access_D = 0;
        end
        repeat(4) begin
            @(negedge clk);
            pmc_cache_miss_D = 1;
            @(posedge clk);
            #1 pmc_cache_miss_D = 0;
        end

        daddr = ADDR_ACC_D;
        iaddr = ADDR_MISS_D;
        de = 1;
        ie = 1;
        drw = 2'b01;
        #10;
        #1;

        check_outputs(32'hA, 32'h4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Testing UART communication events.");
        reset_dut();


        repeat(7) begin
            @(negedge clk);
            pmc_uart_recv = 1;
            @(posedge clk);
            #1 pmc_uart_recv = 0;
        end
        repeat(3) begin
            @(negedge clk);
            pmc_uart_send = 1;
            @(posedge clk);
            #1 pmc_uart_send = 0;
        end

        daddr = ADDR_UART_RECV;
        iaddr = ADDR_UART_SEND;
        de = 1;
        ie = 1;
        drw = 2'b01;
        #10;
        #1;

        check_outputs(32'h7, 32'h3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Testing simultaneous event increments.");
        reset_dut();


        repeat(4) begin
            @(negedge clk);
            pmc_int = 1;
            pmc_uart_send = 1;
            @(posedge clk);
            #1;
            pmc_int = 0;
            pmc_uart_send = 0;
        end

        daddr = ADDR_INT;
        iaddr = ADDR_UART_SEND;
        de = 1;
        ie = 1;
        drw = 2'b01;
        #10;
        #1;

        check_outputs(32'h4, 32'h4);
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
        input [31:0] expected_dout;
        input [31:0] expected_iout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_iout === (expected_iout ^ iout ^ expected_iout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, iout=%h",
                         dout, iout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, iout=%h",
                         expected_dout, expected_iout);
                $display("  Got:      dout=%h, iout=%h",
                         dout, iout);
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
        $dumpvars(0,clk, daddr, de, din, drw, iaddr, ie, pmc_cache_access_D, pmc_cache_access_I, pmc_cache_miss_D, pmc_cache_miss_I, pmc_int, pmc_uart_recv, pmc_uart_send, rst, dout, iout);
    end

endmodule

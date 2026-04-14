`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] data;
    reg [24:0] rdaddress;
    reg rdclken;
    reg [24:0] wraddress;
    reg wrclock;
    reg wren;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .rdaddress(rdaddress),
        .rdclken(rdclken),
        .wraddress(wraddress),
        .wrclock(wrclock),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        wrclock = 0;
        forever #5 wrclock = ~wrclock;
    end

        task reset_dut;

    begin
        wren = 0;
        rdclken = 0;
        data = 16'h0;
        wraddress = 25'h0;
        rdaddress = 25'h0;
        @(posedge wrclock);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        data = 16'hAAAA;
        wraddress = 25'h5;
        wren = 1;
        @(posedge wrclock);
        #2;
        wren = 0;


        rdaddress = 25'h5;
        rdclken = 1;
        #5;

        $display("Testcase 001: Basic Write/Read");
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        data = 16'h5555;
        wraddress = 25'h1FFFFFF;
        wren = 1;
        @(posedge wrclock);
        #2;
        wren = 0;


        rdaddress = 25'h1FFFFFF;
        rdclken = 1;
        #5;

        $display("Testcase 002: Boundary Address Check");
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        data = 16'hBEEF;
        wraddress = 25'h100;
        wren = 1;
        @(posedge wrclock);
        #2;


        data = 16'hDEAD;
        wren = 0;
        @(posedge wrclock);
        #2;


        rdaddress = 25'h100;
        rdclken = 1;
        #5;

        $display("Testcase 003: Write Enable (wren) Verification");
        #1;

        check_outputs(16'hBEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();


        data = 16'h1111;
        wraddress = 25'h200;
        wren = 1;
        @(posedge wrclock);
        #2;


        data = 16'h2222;
        wraddress = 25'h300;
        rdaddress = 25'h200;
        rdclken = 1;
        wren = 1;
        @(posedge wrclock);
        #2;

        $display("Testcase 004: Simultaneous Read/Write");
        #1;

        check_outputs(16'h1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        data = 16'h1010; wraddress = 25'hA; wren = 1; @(posedge wrclock); #2;
        data = 16'h2020; wraddress = 25'hB; wren = 1; @(posedge wrclock); #2;
        data = 16'h3030; wraddress = 25'hC; wren = 1; @(posedge wrclock); #2;
        wren = 0;


        rdaddress = 25'hB;
        rdclken = 1;
        #5;

        $display("Testcase 005: Multiple Sequential Writes");
        #1;

        check_outputs(16'h2020);
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,data, rdaddress, rdclken, wraddress, wrclock, wren, q);
    end

endmodule

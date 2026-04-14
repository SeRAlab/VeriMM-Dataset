`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addr0;
    reg [12:0] addr1;
    reg ce0;
    reg ce1;
    reg clk;
    reg [7:0] d1;
    reg we1;
    wire [7:0] q0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .addr1(addr1),
        .ce0(ce0),
        .ce1(ce1),
        .clk(clk),
        .d1(d1),
        .we1(we1),
        .q0(q0)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr0 = 0;
            addr1 = 0;
            ce0 = 0;
            ce1 = 0;
            we1 = 0;
            d1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Basic Write and Read...");


            addr1 = 13'h0010;
            d1 = 8'hAA;
            ce1 = 1;
            we1 = 1;
            @(posedge clk);
            #1;
            we1 = 0;
            ce1 = 0;


            addr0 = 13'h0010;
            ce0 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Multiple writes, specific read...");


            addr1 = 13'h0001; d1 = 8'h11; ce1 = 1; we1 = 1;
            @(posedge clk); #1;


            addr1 = 13'h0002; d1 = 8'h22; ce1 = 1; we1 = 1;
            @(posedge clk); #1;

            we1 = 0; ce1 = 0;


            addr0 = 13'h0001; ce0 = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Simultaneous Read/Write...");


            addr1 = 13'h0100; d1 = 8'h55; ce1 = 1; we1 = 1;
            @(posedge clk); #1;


            addr0 = 13'h0100; ce0 = 1;
            addr1 = 13'h0200; d1 = 8'h66; ce1 = 1; we1 = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Write Enable (we1) check...");


            addr1 = 13'h0050; d1 = 8'h33; ce1 = 1; we1 = 1;
            @(posedge clk); #1;


            addr1 = 13'h0050; d1 = 8'hFF; ce1 = 1; we1 = 0;
            @(posedge clk); #1;


            addr0 = 13'h0050; ce0 = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Boundary address check...");


            addr1 = 13'h1FFF; d1 = 8'hEF; ce1 = 1; we1 = 1;
            @(posedge clk); #1;


            addr0 = 13'h1FFF; ce0 = 1; we1 = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hEF);
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
        input [7:0] expected_q0;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0)) begin
                $display("PASS");
                $display("  Outputs: q0=%h",
                         q0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h",
                         expected_q0);
                $display("  Got:      q0=%h",
                         q0);
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
        $dumpvars(0,addr0, addr1, ce0, ce1, clk, d1, we1, q0);
    end

endmodule

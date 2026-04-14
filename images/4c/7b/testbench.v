`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [3:0] keyvalue;
    reg lockkey;
    reg reset;
    wire [3:0] pw0;
    wire [3:0] pw1;
    wire [3:0] pw2;
    wire [3:0] pw3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .keyvalue(keyvalue),
        .lockkey(lockkey),
        .reset(reset),
        .pw0(pw0),
        .pw1(pw1),
        .pw2(pw2),
        .pw3(pw3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            lockkey = 0;
            keyvalue = 4'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            keyvalue = 4'h1; @(posedge clk); #1;
            keyvalue = 4'h2; @(posedge clk); #1;
            keyvalue = 4'h3; @(posedge clk); #1;
            keyvalue = 4'h4; @(posedge clk); #1;
            #1;

            check_outputs(4'h1, 4'h2, 4'h3, 4'h4);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            keyvalue = 4'hA; @(posedge clk); #1;
            keyvalue = 4'hB; @(posedge clk); #1;

            reset = 1; @(posedge clk); #1;
            reset = 0;

            keyvalue = 4'h5; @(posedge clk); #1;
            keyvalue = 4'h6; @(posedge clk); #1;
            keyvalue = 4'h7; @(posedge clk); #1;
            keyvalue = 4'h8; @(posedge clk); #1;
            #1;

            check_outputs(4'h5, 4'h6, 4'h7, 4'h8);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            keyvalue = 4'hF; @(posedge clk); #1;
            lockkey = 1; @(posedge clk); #1;
            lockkey = 0;
            keyvalue = 4'h9; @(posedge clk); #1;
            keyvalue = 4'h8; @(posedge clk); #1;
            keyvalue = 4'h7; @(posedge clk); #1;
            keyvalue = 4'h6; @(posedge clk); #1;
            #1;

            check_outputs(4'h9, 4'h8, 4'h7, 4'h6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            keyvalue = 4'h1; @(posedge clk); #1;
            clear = 1;    @(posedge clk); #1;
            clear = 0;
            keyvalue = 4'h3; @(posedge clk); #1;
            keyvalue = 4'h4; @(posedge clk); #1;
            #1;

            check_outputs(4'h1, 4'h0, 4'h3, 4'h4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            keyvalue = 4'h1; @(posedge clk); #1;
            keyvalue = 4'h2; @(posedge clk); #1;
            keyvalue = 4'h3; @(posedge clk); #1;
            keyvalue = 4'h4; @(posedge clk); #1;

            keyvalue = 4'hA; @(posedge clk); #1;
            keyvalue = 4'hB; @(posedge clk); #1;
            keyvalue = 4'hC; @(posedge clk); #1;
            keyvalue = 4'hD; @(posedge clk); #1;
            #1;

            check_outputs(4'hA, 4'hB, 4'hC, 4'hD);
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
        input [3:0] expected_pw0;
        input [3:0] expected_pw1;
        input [3:0] expected_pw2;
        input [3:0] expected_pw3;
        begin
            if (expected_pw0 === (expected_pw0 ^ pw0 ^ expected_pw0) &&
                expected_pw1 === (expected_pw1 ^ pw1 ^ expected_pw1) &&
                expected_pw2 === (expected_pw2 ^ pw2 ^ expected_pw2) &&
                expected_pw3 === (expected_pw3 ^ pw3 ^ expected_pw3)) begin
                $display("PASS");
                $display("  Outputs: pw0=%h, pw1=%h, pw2=%h, pw3=%h",
                         pw0, pw1, pw2, pw3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pw0=%h, pw1=%h, pw2=%h, pw3=%h",
                         expected_pw0, expected_pw1, expected_pw2, expected_pw3);
                $display("  Got:      pw0=%h, pw1=%h, pw2=%h, pw3=%h",
                         pw0, pw1, pw2, pw3);
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
        $dumpvars(0,clear, clk, keyvalue, lockkey, reset, pw0, pw1, pw2, pw3);
    end

endmodule

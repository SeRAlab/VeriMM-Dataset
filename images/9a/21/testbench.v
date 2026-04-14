`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a1;
    reg [15:0] a2;
    reg [15:0] a3;
    reg ans_any;
    reg clk_sys;
    reg in;
    reg r;
    reg ready;
    reg w;
    reg zw;
    wire [15:0] dad;
    wire [15:0] ddt;
    wire din;
    wire [3:0] dnb;
    wire dpn;
    wire dr;
    wire dw;
    wire zg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .ans_any(ans_any),
        .clk_sys(clk_sys),
        .in(in),
        .r(r),
        .ready(ready),
        .w(w),
        .zw(zw),
        .dad(dad),
        .ddt(ddt),
        .din(din),
        .dnb(dnb),
        .dpn(dpn),
        .dr(dr),
        .dw(dw),
        .zg(zg)
    );

    // Clock generation (10ns period)
    initial begin
        clk_sys = 0;
        forever #5 clk_sys = ~clk_sys;
    end

        task reset_dut;

    begin
        ready = 0;
        r = 0;
        w = 0;
        in = 0;
        a1 = 8'h0;
        a2 = 16'h0;
        a3 = 16'h0;
        zw = 0;
        ans_any = 1;
        @(posedge clk_sys);
        #1;
        ans_any = 0;
        @(posedge clk_sys);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Write Request");
        ready = 1;
        w = 1;
        a1 = 8'h0A;
        a2 = 16'h1234;
        a3 = 16'hABCD;
        zw = 0;
        @(posedge clk_sys);
        #2;

        #1;


        check_outputs(16'h1234, 16'hABCD, 1'b0, 4'hA, 1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Read Request");
        ready = 1;
        r = 1;
        a1 = 8'h05;
        a2 = 16'h55AA;
        a3 = 16'h0000;
        zw = 0;
        @(posedge clk_sys);
        #2;

        #1;


        check_outputs(16'h55AA, 16'h0000, 1'b0, 4'h5, 1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Request while Not Ready");
        ready = 0;
        r = 1;
        a2 = 16'hFFFF;
        @(posedge clk_sys);
        #2;

        #1;


        check_outputs(16'h0000, 16'h0000, 1'b0, 4'h0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: ZW Signal Conditioning");
        ready = 1;
        w = 1;
        a2 = 16'hBEEF;
        a3 = 16'hCAFE;
        zw = 1;
        @(posedge clk_sys);
        #2;

        #1;


        check_outputs(16'hBEEF, 16'h0000, 1'b0, 4'h0, 1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Input Request and Acknowledgment");
        ready = 1;
        in = 1;
        a2 = 16'h8888;
        @(posedge clk_sys);
        #2;

        if (zg === 1'b1 && din === 1'b1) begin
            ans_any = 1;
            @(posedge clk_sys);
            #2;
            ans_any = 0;

            #1;


            check_outputs(16'h0000, 16'h0000, 1'b0, 4'h0, 1'b0, 1'b0, 1'b0, 1'b0);
        end else begin
            $display("Failed to enter REQ state");
            fail_count = fail_count + 1;
        end
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
        input [15:0] expected_dad;
        input [15:0] expected_ddt;
        input expected_din;
        input [3:0] expected_dnb;
        input expected_dpn;
        input expected_dr;
        input expected_dw;
        input expected_zg;
        begin
            if (expected_dad === (expected_dad ^ dad ^ expected_dad) &&
                expected_ddt === (expected_ddt ^ ddt ^ expected_ddt) &&
                expected_din === (expected_din ^ din ^ expected_din) &&
                expected_dnb === (expected_dnb ^ dnb ^ expected_dnb) &&
                expected_dpn === (expected_dpn ^ dpn ^ expected_dpn) &&
                expected_dr === (expected_dr ^ dr ^ expected_dr) &&
                expected_dw === (expected_dw ^ dw ^ expected_dw) &&
                expected_zg === (expected_zg ^ zg ^ expected_zg)) begin
                $display("PASS");
                $display("  Outputs: dad=%h, ddt=%h, din=%b, dnb=%h, dpn=%b, dr=%b, dw=%b, zg=%b",
                         dad, ddt, din, dnb, dpn, dr, dw, zg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dad=%h, ddt=%h, din=%b, dnb=%h, dpn=%b, dr=%b, dw=%b, zg=%b",
                         expected_dad, expected_ddt, expected_din, expected_dnb, expected_dpn, expected_dr, expected_dw, expected_zg);
                $display("  Got:      dad=%h, ddt=%h, din=%b, dnb=%h, dpn=%b, dr=%b, dw=%b, zg=%b",
                         dad, ddt, din, dnb, dpn, dr, dw, zg);
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
        $dumpvars(0,a1, a2, a3, ans_any, clk_sys, in, r, ready, w, zw, dad, ddt, din, dnb, dpn, dr, dw, zg);
    end

endmodule

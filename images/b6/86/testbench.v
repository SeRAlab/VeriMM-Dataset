`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [26:0] a;
    reg [31:0] b;
    reg clk;
    reg res;
    wire [27:0] outp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .res(res),
        .outp(outp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        res = 0;
        a = 0;
        b = 0;
        @(posedge clk);
        #1 res = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset check");
        res = 0;
        a = 27'h7FFFFFF;
        b = 32'hFFFFFFFF;
        #10;
        #1;

        check_outputs(28'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Positive Addition");
        reset_dut();
        a = 27'h0000064;
        b = 32'h000000C8;
        @(posedge clk);
        #1;

        #1;


        check_outputs(28'h000012C);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Mixed Signs (A+, B-)");
        reset_dut();
        a = 27'h00003E8;
        b = 32'h80000064;
        @(posedge clk);
        #1;


        #1;



        check_outputs(28'h0000384);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Both Negative");
        reset_dut();
        a = 27'h4000005;
        b = 32'h8000000A;
        @(posedge clk);
        #1;

        #1;


        check_outputs(28'h800000F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Large values / Overflow Check");
        reset_dut();
        a = 27'h3FFFFFF;
        b = 32'h00000002;
        @(posedge clk);
        #1;

        #1;


        check_outputs(28'h4000001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Fractional Part Comparison Logic");
        reset_dut();
        a = 27'h0AAAAAA;
        b = 32'h0555555;
        @(posedge clk);
        #1;
        #1;

        check_outputs(28'h0FFFFFF);
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
        input [27:0] expected_outp;
        begin
            if (expected_outp === (expected_outp ^ outp ^ expected_outp)) begin
                $display("PASS");
                $display("  Outputs: outp=%h",
                         outp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outp=%h",
                         expected_outp);
                $display("  Got:      outp=%h",
                         outp);
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
        $dumpvars(0,a, b, clk, res, outp);
    end

endmodule

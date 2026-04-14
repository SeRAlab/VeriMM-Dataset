`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg [9:0] inAddr;
    reg [9:0] outAddr;
    reg writeSel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .inAddr(inAddr),
        .outAddr(outAddr),
        .writeSel(writeSel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 0;
            inAddr = 0;
            outAddr = 0;
            writeSel = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            in = 16'hABCD;
            inAddr = 10'd10;
            writeSel = 1;
            @(posedge clk);
            #1;
            writeSel = 0;

            outAddr = 10'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            in = 16'h5555;
            inAddr = 10'd20;
            writeSel = 0;
            @(posedge clk);
            #1;

            outAddr = 10'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            in = 16'h1111;
            inAddr = 10'd0;
            writeSel = 1;
            @(posedge clk);
            #1;

            in = 16'hFFFF;
            inAddr = 10'd1023;
            writeSel = 1;
            @(posedge clk);
            #1;
            writeSel = 0;

            outAddr = 10'd0;
            @(posedge clk);
            #1;
            outAddr = 10'd1023;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            inAddr = 10'd100; in = 16'h1001; writeSel = 1; @(posedge clk); #1;
            inAddr = 10'd101; in = 16'h1002; writeSel = 1; @(posedge clk); #1;
            writeSel = 0;

            outAddr = 10'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            in = 16'hCAFE; inAddr = 10'd50; writeSel = 1; @(posedge clk); #1;

            in = 16'hBEEF; inAddr = 10'd60; writeSel = 1; outAddr = 10'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hCAFE);
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, inAddr, outAddr, writeSel, out);
    end

endmodule

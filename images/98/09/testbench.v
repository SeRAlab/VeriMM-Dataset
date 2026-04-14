`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg ce;
    reg clk;
    reg [31:0] di;
    reg oe;
    reg rst;
    reg we;
    wire [31:0] doq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .ce(ce),
        .clk(clk),
        .di(di),
        .oe(oe),
        .rst(rst),
        .we(we),
        .doq(doq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ce = 0;
            we = 0;
            oe = 0;
            addr = 0;
            di = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;


            @(posedge clk);
            addr = 7'h0A;
            di = 32'h55AA55AA;
            ce = 1;
            we = 1;
            oe = 0;

            @(posedge clk);

            we = 0;
            oe = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;


            @(posedge clk);
            addr = 7'h20;
            di = 32'h12345678;
            ce = 1;
            we = 1;
            oe = 0;

            @(posedge clk);

            we = 0;
            oe = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;


            @(posedge clk);
            addr = 7'h30;
            di = 32'hDEADBEEF;
            ce = 0;
            we = 1;
            oe = 0;

            @(posedge clk);

            ce = 1;
            we = 0;
            oe = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;


            @(posedge clk);
            addr = 7'h40;
            di = 32'hAAAAAAAA;
            ce = 1;
            we = 1;
            oe = 1;

            @(posedge clk);

            di = 32'hBBBBBBBB;
            we = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;


            @(posedge clk);
            addr = 7'h7F;
            di = 32'hFFFFFFFF;
            ce = 1;
            we = 1;
            oe = 0;

            @(posedge clk);
            we = 0;
            oe = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;


            @(posedge clk);
            addr = 7'h05;
            di = 32'h11111111;
            ce = 1;
            we = 1;
            oe = 0;

            @(posedge clk);

            di = 32'h22222222;

            @(posedge clk);
            we = 0;
            oe = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h22222222);
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
        input [31:0] expected_doq;
        begin
            if (expected_doq === (expected_doq ^ doq ^ expected_doq)) begin
                $display("PASS");
                $display("  Outputs: doq=%h",
                         doq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: doq=%h",
                         expected_doq);
                $display("  Got:      doq=%h",
                         doq);
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
        $dumpvars(0,addr, ce, clk, di, oe, rst, we, doq);
    end

endmodule

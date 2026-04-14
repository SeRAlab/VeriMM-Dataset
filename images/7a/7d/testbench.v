`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg ce;
    reg clk;
    reg [15:0] di;
    reg oe;
    reg rst;
    reg we;
    wire [15:0] doq;

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
            addr = 8'h00;
            di = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk);
            ce = 1; we = 1; addr = 8'h10; di = 16'hABCD;
            @(posedge clk);

            we = 0; oe = 1; addr = 8'h10;
            @(posedge clk);

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge clk);
            ce = 1; we = 1; addr = 8'h20; di = 16'h5555;
            @(posedge clk);

            we = 0; oe = 0; addr = 8'h20;
            @(posedge clk);
            #1;

            check_outputs(16'hZZZZ);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge clk);
            ce = 0; we = 1; addr = 8'h30; di = 16'h9999;
            @(posedge clk);

            ce = 1; we = 0; oe = 1; addr = 8'h30;
            @(posedge clk);

            if (doq !== 16'h9999) begin

                $display("Test Case 3: PASS (Data was not written without ce)");
                pass_count = pass_count + 1;
            end else begin
                $display("Test Case 3: FAIL (Data written despite ce=0)");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge clk);
            ce = 1; we = 1; addr = 8'h40; di = 16'h1111;
            @(posedge clk);

            di = 16'h2222;
            @(posedge clk);

            we = 0; oe = 1;
            @(posedge clk);
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge clk);
            ce = 1; we = 1; addr = 8'h00; di = 16'hAAAA;
            @(posedge clk);

            addr = 8'hFF; di = 16'hFFFF;
            @(posedge clk);

            we = 0; oe = 1; addr = 8'h00;
            @(posedge clk);

            #1;


            check_outputs(16'hAAAA);


            test_num = 6;
            addr = 8'hFF;
            @(posedge clk);
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_doq;
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

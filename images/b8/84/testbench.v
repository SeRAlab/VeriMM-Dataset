`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] din;
    reg [3:0] raddr;
    reg [3:0] waddr;
    reg wr;
    wire [63:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .raddr(raddr),
        .waddr(waddr),
        .wr(wr),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr = 0;
            din = 0;
            waddr = 0;
            raddr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            wr = 1;
            waddr = 4'h5;
            din = 64'hFEDCBA9876543210;
            @(posedge clk);
            #1;
            wr = 0;

            raddr = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            wr = 1;
            waddr = 4'hF;
            din = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;

            waddr = 4'h0;
            din = 64'h1234567812345678;
            @(posedge clk);
            #1;
            wr = 0;

            raddr = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            wr = 1;
            waddr = 4'h2;
            din = 64'hAAAAAAAAAAAAAAAA;
            @(posedge clk);
            #1;

            wr = 0;
            waddr = 4'h2;
            din = 64'hBBBBBBBBBBBBBBBB;
            @(posedge clk);
            #1;

            raddr = 4'h2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            wr = 1;

            waddr = 4'h1; din = 64'h1; @(posedge clk); #1;
            waddr = 4'h2; din = 64'h2; @(posedge clk); #1;
            waddr = 4'h3; din = 64'h3; @(posedge clk); #1;
            wr = 0;

            raddr = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            wr = 1;
            waddr = 4'h7;
            din = 64'h7777777777777777;
            @(posedge clk);
            #1;

            wr = 1;
            waddr = 4'h8;
            din = 64'h8888888888888888;
            raddr = 4'h7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h7777777777777777);
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
        input [63:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, raddr, waddr, wr, dout);
    end

endmodule

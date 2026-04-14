`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [14:0] madr;
    reg [31:0] mdin;
    reg mreq;
    reg mwe;
    reg rst;
    reg [14:0] sram_adr;
    reg [31:0] sram_din;
    reg sram_re;
    reg [14:0] wadr;
    reg [31:0] wdin;
    reg wreq;
    reg wwe;
    wire mdout;
    wire [31:0] sram_dout;
    wire sram_we;
    wire wack;
    wire [31:0] wdout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .madr(madr),
        .mdin(mdin),
        .mreq(mreq),
        .mwe(mwe),
        .rst(rst),
        .sram_adr(sram_adr),
        .sram_din(sram_din),
        .sram_re(sram_re),
        .wadr(wadr),
        .wdin(wdin),
        .wreq(wreq),
        .wwe(wwe),
        .mdout(mdout),
        .sram_dout(sram_dout),
        .sram_we(sram_we),
        .wack(wack),
        .wdout(wdout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            madr = 0;
            mdin = 0;
            mreq = 0;
            mwe = 0;
            sram_adr = 0;
            sram_din = 0;
            sram_re = 0;
            wadr = 0;
            wdin = 0;
            wreq = 0;
            wwe = 0;
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
            #1;

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            wreq = 1;
            wwe = 1;
            wdin = 32'hAAAA_5555;
            wadr = 15'h000A;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'hAAAA_5555, 1'b1, 1'b1, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            mreq = 1;
            mwe = 1;
            mdin = 32'h1234_ABCD;
            madr = 15'h000B;
            wreq = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 32'h1234_ABCD, 1'b1, 1'b0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            wreq = 1;
            wwe = 1;
            wdin = 32'hWWWW_WWWW;
            wadr = 15'h0010;

            mreq = 1;
            mwe = 1;
            mdin = 32'hMMMM_MMMM;
            madr = 15'h0020;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'hWWWW_WWWW, 1'b1, 1'b1, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            sram_din = 32'hCAFE_BABE;
            sram_re = 1;
            wreq = 1;
            wwe = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 1'b1, 32'hCAFE_BABE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            mreq = 1;
            mwe = 0;
            sram_din = 32'h55AA_CC33;
            wreq = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 32'h0, 1'b0, 1'b0, 32'h55AA_CC33);
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
        input expected_mdout;
        input [31:0] expected_sram_dout;
        input expected_sram_we;
        input expected_wack;
        input [31:0] expected_wdout;
        begin
            if (expected_mdout === (expected_mdout ^ mdout ^ expected_mdout) &&
                expected_sram_dout === (expected_sram_dout ^ sram_dout ^ expected_sram_dout) &&
                expected_sram_we === (expected_sram_we ^ sram_we ^ expected_sram_we) &&
                expected_wack === (expected_wack ^ wack ^ expected_wack) &&
                expected_wdout === (expected_wdout ^ wdout ^ expected_wdout)) begin
                $display("PASS");
                $display("  Outputs: mdout=%b, sram_dout=%h, sram_we=%b, wack=%b, wdout=%h",
                         mdout, sram_dout, sram_we, wack, wdout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mdout=%b, sram_dout=%h, sram_we=%b, wack=%b, wdout=%h",
                         expected_mdout, expected_sram_dout, expected_sram_we, expected_wack, expected_wdout);
                $display("  Got:      mdout=%b, sram_dout=%h, sram_we=%b, wack=%b, wdout=%h",
                         mdout, sram_dout, sram_we, wack, wdout);
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
        $dumpvars(0,clk, madr, mdin, mreq, mwe, rst, sram_adr, sram_din, sram_re, wadr, wdin, wreq, wwe, mdout, sram_dout, sram_we, wack, wdout);
    end

endmodule

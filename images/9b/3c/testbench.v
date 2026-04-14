`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] madr;
    reg [31:0] mdin;
    reg mreq;
    reg mwe;
    reg phy_clk;
    reg rst;
    reg [31:0] sram_din;
    reg [14:0] wadr;
    reg wclk;
    reg [31:0] wdin;
    reg wreq;
    reg wwe;
    wire mack;
    wire [31:0] mdout;
    wire [14:0] sram_adr;
    wire [31:0] sram_dout;
    wire sram_re;
    wire sram_we;
    wire wack;
    wire [31:0] wdout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .madr(madr),
        .mdin(mdin),
        .mreq(mreq),
        .mwe(mwe),
        .phy_clk(phy_clk),
        .rst(rst),
        .sram_din(sram_din),
        .wadr(wadr),
        .wclk(wclk),
        .wdin(wdin),
        .wreq(wreq),
        .wwe(wwe),
        .mack(mack),
        .mdout(mdout),
        .sram_adr(sram_adr),
        .sram_dout(sram_dout),
        .sram_re(sram_re),
        .sram_we(sram_we),
        .wack(wack),
        .wdout(wdout)
    );

    // Clock generation (10ns period)
    initial begin
        phy_clk = 0;
        forever #5 phy_clk = ~phy_clk;
    end

        task reset_dut;

        begin
            rst = 1;
            madr = 0; mdin = 0; mreq = 0; mwe = 0;
            wadr = 0; wdin = 0; wreq = 0; wwe = 0;
            sram_din = 0;
            repeat(5) @(posedge phy_clk);
            rst = 0;
            repeat(2) @(posedge phy_clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Master M Write Operation");
            @(posedge phy_clk);
            madr = 15'h1234;
            mdin = 32'hDEADBEEF;
            mwe = 1;
            mreq = 1;


            repeat(2) @(posedge phy_clk);


            #1;



            check_outputs(1'b1, 32'h0, 15'h1234, 32'hDEADBEEF, 1'b0, 1'b1, 1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Master M Read Operation");
            @(posedge phy_clk);
            madr = 15'h5A5A;
            mwe = 0;
            mreq = 1;
            sram_din = 32'hCAFEFACE;

            repeat(2) @(posedge phy_clk);


            #1;



            check_outputs(1'b1, 32'hCAFEFACE, 15'h5A5A, 32'h0, 1'b1, 1'b0, 1'b0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Master W Write Operation");
            @(posedge phy_clk);
            wadr = 15'h0ABC;
            wdin = 32'h12345678;
            wwe = 1;
            wreq = 1;

            repeat(3) @(posedge phy_clk);


            #1;



            check_outputs(1'b0, 32'h0, 15'h0ABC, 32'h12345678, 1'b0, 1'b1, 1'b1, 32'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Master W Read Operation");
            @(posedge phy_clk);
            wadr = 15'h7FFF;
            wwe = 0;
            wreq = 1;
            sram_din = 32'h88776655;

            repeat(3) @(posedge phy_clk);


            #1;



            check_outputs(1'b0, 32'h0, 15'h7FFF, 32'h0, 1'b1, 1'b0, 1'b1, 32'h88776655);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Priority Test (Simultaneous M and W)");
            @(posedge phy_clk);

            madr = 15'h1111;
            mdin = 32'hMMMMMMMM;
            mwe = 1;
            mreq = 1;

            wadr = 15'h2222;
            wdin = 32'hWWWWWWWW;
            wwe = 1;
            wreq = 1;

            repeat(2) @(posedge phy_clk);



            #1;




            check_outputs(1'b1, 32'h0, 15'h1111, 32'hMMMMMMMM, 1'b0, 1'b1, 1'b0, 32'h0);
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
        input expected_mack;
        input [31:0] expected_mdout;
        input [14:0] expected_sram_adr;
        input [31:0] expected_sram_dout;
        input expected_sram_re;
        input expected_sram_we;
        input expected_wack;
        input [31:0] expected_wdout;
        begin
            if (expected_mack === (expected_mack ^ mack ^ expected_mack) &&
                expected_mdout === (expected_mdout ^ mdout ^ expected_mdout) &&
                expected_sram_adr === (expected_sram_adr ^ sram_adr ^ expected_sram_adr) &&
                expected_sram_dout === (expected_sram_dout ^ sram_dout ^ expected_sram_dout) &&
                expected_sram_re === (expected_sram_re ^ sram_re ^ expected_sram_re) &&
                expected_sram_we === (expected_sram_we ^ sram_we ^ expected_sram_we) &&
                expected_wack === (expected_wack ^ wack ^ expected_wack) &&
                expected_wdout === (expected_wdout ^ wdout ^ expected_wdout)) begin
                $display("PASS");
                $display("  Outputs: mack=%b, mdout=%h, sram_adr=%h, sram_dout=%h, sram_re=%b, sram_we=%b, wack=%b, wdout=%h",
                         mack, mdout, sram_adr, sram_dout, sram_re, sram_we, wack, wdout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mack=%b, mdout=%h, sram_adr=%h, sram_dout=%h, sram_re=%b, sram_we=%b, wack=%b, wdout=%h",
                         expected_mack, expected_mdout, expected_sram_adr, expected_sram_dout, expected_sram_re, expected_sram_we, expected_wack, expected_wdout);
                $display("  Got:      mack=%b, mdout=%h, sram_adr=%h, sram_dout=%h, sram_re=%b, sram_we=%b, wack=%b, wdout=%h",
                         mack, mdout, sram_adr, sram_dout, sram_re, sram_we, wack, wdout);
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
        $dumpvars(0,madr, mdin, mreq, mwe, phy_clk, rst, sram_din, wadr, wclk, wdin, wreq, wwe, mack, mdout, sram_adr, sram_dout, sram_re, sram_we, wack, wdout);
    end

endmodule

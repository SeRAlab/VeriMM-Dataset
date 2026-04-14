`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg [13:0] chr_ain;
    reg clk;
    reg [21:0] mmc1_aout;
    reg [3:0] mmc1_chr;
    reg [15:0] prg_ain;
    reg reset;
    wire [21:0] chr_aout;
    wire irq;
    wire [21:0] prg_aout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .chr_ain(chr_ain),
        .clk(clk),
        .mmc1_aout(mmc1_aout),
        .mmc1_chr(mmc1_chr),
        .prg_ain(prg_ain),
        .reset(reset),
        .chr_aout(chr_aout),
        .irq(irq),
        .prg_aout(prg_aout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        ce = 0;
        prg_ain = 16'h0000;
        chr_ain = 14'h0000;
        mmc1_chr = 4'h0;
        mmc1_aout = 22'h0;
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Reset State Check");
        reset_dut();



        #1;




        check_outputs(22'h0, 1'b0, 22'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: PRG Address Mapping (Lower)");
        reset_dut();
        @(posedge clk);
        ce = 1;
        prg_ain = 16'h8000;
        mmc1_aout = 22'h048000;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(22'h0, 1'b0, 22'h048000);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: PRG Address Mapping (Upper/Unlocked)");
        reset_dut();
        @(posedge clk);
        ce = 1;
        prg_ain = 16'hC000;
        mmc1_aout = 22'h3FC000;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(22'h0, 1'b0, 22'h3FC000);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: CHR Memory Mapping");
        reset_dut();
        @(posedge clk);
        chr_ain = 14'h1000;
        mmc1_chr = 4'hA;



        repeat(2) @(posedge clk);



        #1;




        check_outputs(22'h00A000 | chr_ain, 1'b0, 22'h0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: IRQ Signal Generation");
        reset_dut();
        ce = 1;


        repeat(100) @(posedge clk);


        #1;



        check_outputs(22'h0, 1'b1, 22'h0);
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
        input [21:0] expected_chr_aout;
        input expected_irq;
        input [21:0] expected_prg_aout;
        begin
            if (expected_chr_aout === (expected_chr_aout ^ chr_aout ^ expected_chr_aout) &&
                expected_irq === (expected_irq ^ irq ^ expected_irq) &&
                expected_prg_aout === (expected_prg_aout ^ prg_aout ^ expected_prg_aout)) begin
                $display("PASS");
                $display("  Outputs: chr_aout=%h, irq=%b, prg_aout=%h",
                         chr_aout, irq, prg_aout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: chr_aout=%h, irq=%b, prg_aout=%h",
                         expected_chr_aout, expected_irq, expected_prg_aout);
                $display("  Got:      chr_aout=%h, irq=%b, prg_aout=%h",
                         chr_aout, irq, prg_aout);
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
        $dumpvars(0,ce, chr_ain, clk, mmc1_aout, mmc1_chr, prg_ain, reset, chr_aout, irq, prg_aout);
    end

endmodule

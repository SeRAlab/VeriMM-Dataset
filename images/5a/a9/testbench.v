`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg [13:0] chr_ain;
    reg clk;
    reg [31:0] flags;
    reg [15:0] prg_ain;
    reg [7:0] prg_din;
    reg prg_read;
    reg prg_write;
    reg reset;
    wire chr_allow;
    wire [21:0] chr_aout;
    wire prg_allow;
    wire [21:0] prg_aout;
    wire vram_a10;
    wire vram_ce;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .chr_ain(chr_ain),
        .clk(clk),
        .flags(flags),
        .prg_ain(prg_ain),
        .prg_din(prg_din),
        .prg_read(prg_read),
        .prg_write(prg_write),
        .reset(reset),
        .chr_allow(chr_allow),
        .chr_aout(chr_aout),
        .prg_allow(prg_allow),
        .prg_aout(prg_aout),
        .vram_a10(vram_a10),
        .vram_ce(vram_ce)
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
            flags = 32'h0;
            prg_ain = 16'h0;
            prg_din = 8'h0;
            prg_read = 0;
            prg_write = 0;
            chr_ain = 14'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset and Initial State", test_num);
            reset_dut();




            #1;





            check_outputs(1'b1, 22'h0, 1'b0, 22'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: PRG Read Access (0x8000)", test_num);
            reset_dut();

            ce = 1;
            flags = 32'h00000001;
            prg_ain = 16'h8000;
            prg_read = 1;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 22'h0, 1'b1, 22'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: CHR ROM Access (0x1000)", test_num);
            reset_dut();

            ce = 1;
            chr_ain = 14'h1000;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 22'h1000, 1'b0, 22'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: VRAM Mirroring (Vertical)", test_num);
            reset_dut();

            ce = 1;
            flags[0] = 0;
            chr_ain = 14'h2400;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 22'h2400, 1'b0, 22'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: VRAM Mirroring (Horizontal)", test_num);
            reset_dut();

            ce = 1;
            flags[0] = 1;
            chr_ain = 14'h2400;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 22'h2400, 1'b0, 22'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: PRG Write Protection", test_num);
            reset_dut();

            ce = 1;
            prg_ain = 16'hC000;
            prg_write = 1;
            prg_din = 8'hFF;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 22'h0, 1'b0, 22'h4000, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Chip Enable Disable", test_num);
            reset_dut();

            ce = 0;
            prg_ain = 16'h8000;
            chr_ain = 14'h1000;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 22'h1000, 1'b0, 22'h0, 1'b0, 1'b1);
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
        testcase007();
        
        
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
        input expected_chr_allow;
        input [21:0] expected_chr_aout;
        input expected_prg_allow;
        input [21:0] expected_prg_aout;
        input expected_vram_a10;
        input expected_vram_ce;
        begin
            if (expected_chr_allow === (expected_chr_allow ^ chr_allow ^ expected_chr_allow) &&
                expected_chr_aout === (expected_chr_aout ^ chr_aout ^ expected_chr_aout) &&
                expected_prg_allow === (expected_prg_allow ^ prg_allow ^ expected_prg_allow) &&
                expected_prg_aout === (expected_prg_aout ^ prg_aout ^ expected_prg_aout) &&
                expected_vram_a10 === (expected_vram_a10 ^ vram_a10 ^ expected_vram_a10) &&
                expected_vram_ce === (expected_vram_ce ^ vram_ce ^ expected_vram_ce)) begin
                $display("PASS");
                $display("  Outputs: chr_allow=%b, chr_aout=%h, prg_allow=%b, prg_aout=%h, vram_a10=%b, vram_ce=%b",
                         chr_allow, chr_aout, prg_allow, prg_aout, vram_a10, vram_ce);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: chr_allow=%b, chr_aout=%h, prg_allow=%b, prg_aout=%h, vram_a10=%b, vram_ce=%b",
                         expected_chr_allow, expected_chr_aout, expected_prg_allow, expected_prg_aout, expected_vram_a10, expected_vram_ce);
                $display("  Got:      chr_allow=%b, chr_aout=%h, prg_allow=%b, prg_aout=%h, vram_a10=%b, vram_ce=%b",
                         chr_allow, chr_aout, prg_allow, prg_aout, vram_a10, vram_ce);
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
        $dumpvars(0,ce, chr_ain, clk, flags, prg_ain, prg_din, prg_read, prg_write, reset, chr_allow, chr_aout, prg_allow, prg_aout, vram_a10, vram_ce);
    end

endmodule

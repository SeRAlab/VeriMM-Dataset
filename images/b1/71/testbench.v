`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg arst;
    reg clk;
    reg en;
    reg ldin;
    reg ldout;
    reg srst;
    reg vzin;
    reg vzout;
    wire [7:0] din;
    wire lzout;
    wire vdin;
    wire vdout;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arst(arst),
        .clk(clk),
        .en(en),
        .ldin(ldin),
        .ldout(ldout),
        .srst(srst),
        .vzin(vzin),
        .vzout(vzout),
        .din(din),
        .lzout(lzout),
        .vdin(vdin),
        .vdout(vdout),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            arst = 1;
            srst = 0;
            en = 0;
            ldin = 0;
            ldout = 0;
            vzin = 0;
            vzout = 0;
            #10;
            arst = 0;
            #10;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Initial Reset State");
            reset_dut();


            #1;



            check_outputs(8'h00, 1'b1, 1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Single Write Operation");
            reset_dut();
            en = 1;
            vzin = 1;
            ldin = 1;
            @(posedge clk);
            #1;
            ldin = 0;
            vzin = 0;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 1'b1, 8'h00);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nTestcase 003: Fill Buffer to Capacity");
            reset_dut();
            en = 1;
            vzin = 1;
            ldin = 1;

            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            ldin = 0;

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Enable Signal Gating");
            reset_dut();
            en = 0;
            vzin = 1;
            ldin = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b1, 1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Synchronous Reset");
            reset_dut();
            en = 1;
            vzin = 1;
            ldin = 1;
            @(posedge clk);
            #1;
            srst = 1;
            @(posedge clk);
            #1;
            srst = 0;

            #1;


            check_outputs(8'h00, 1'b1, 1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Simultaneous Load and Unload");
            reset_dut();
            en = 1;

            vzin = 1; ldin = 1;
            @(posedge clk);
            #1;

            vzout = 1; ldout = 1;
            vzin = 1; ldin = 1;
            @(posedge clk);
            #1;
            ldin = 0; ldout = 0;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 1'b1, 8'h00);
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
        input [7:0] expected_din;
        input expected_lzout;
        input expected_vdin;
        input expected_vdout;
        input [7:0] expected_z;
        begin
            if (expected_din === (expected_din ^ din ^ expected_din) &&
                expected_lzout === (expected_lzout ^ lzout ^ expected_lzout) &&
                expected_vdin === (expected_vdin ^ vdin ^ expected_vdin) &&
                expected_vdout === (expected_vdout ^ vdout ^ expected_vdout) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: din=%h, lzout=%b, vdin=%b, vdout=%b, z=%h",
                         din, lzout, vdin, vdout, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din=%h, lzout=%b, vdin=%b, vdout=%b, z=%h",
                         expected_din, expected_lzout, expected_vdin, expected_vdout, expected_z);
                $display("  Got:      din=%h, lzout=%b, vdin=%b, vdout=%b, z=%h",
                         din, lzout, vdin, vdout, z);
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
        $dumpvars(0,arst, clk, en, ldin, ldout, srst, vzin, vzout, din, lzout, vdin, vdout, z);
    end

endmodule

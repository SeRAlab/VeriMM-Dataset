`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bclk;
    reg clk;
    reg [1:0] cs;
    reg [15:0] din;
    reg [2:0] hi_addr;
    reg lba;
    reg [15:0] nram_a;
    reg nram_clk;
    reg [7:0] nram_din;
    reg nram_we;
    reg oe;
    reg reset;
    reg rw;
    wire [15:0] dout;
    wire [7:0] nram_dout;
    wire rb_wait;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bclk(bclk),
        .clk(clk),
        .cs(cs),
        .din(din),
        .hi_addr(hi_addr),
        .lba(lba),
        .nram_a(nram_a),
        .nram_clk(nram_clk),
        .nram_din(nram_din),
        .nram_we(nram_we),
        .oe(oe),
        .reset(reset),
        .rw(rw),
        .dout(dout),
        .nram_dout(nram_dout),
        .rb_wait(rb_wait)
    );

    // Clock generation (10ns period)
    initial begin
        bclk = 0;
        forever #5 bclk = ~bclk;
    end

        task reset_dut;

        begin
            reset = 1;
            cs = 2'b00;
            din = 16'h0000;
            hi_addr = 3'b000;
            lba = 0;
            nram_a = 16'h0000;
            nram_din = 8'h00;
            nram_we = 0;
            oe = 0;
            rw = 0;
            repeat (5) @(posedge bclk);
            reset = 0;
            repeat (2) @(posedge bclk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            #1;



            check_outputs(16'h0000, 8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge bclk);
            cs = 2'b01;
            rw = 0;
            din = 16'hA55A;
            hi_addr = 3'b010;
            repeat (2) @(posedge bclk);

            #1;


            check_outputs(16'h0000, 8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge bclk);
            cs = 2'b01;
            rw = 1;
            oe = 1;
            nram_din = 8'hC3;
            repeat (2) @(posedge bclk);

            #1;


            check_outputs(16'h00C3, 8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge bclk);
            cs = 2'b01;
            rw = 1;
            oe = 0;
            nram_din = 8'hFF;
            repeat (2) @(posedge bclk);
            #1;

            check_outputs(16'h0000, 8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge bclk);
            cs = 2'b00;
            rw = 0;
            din = 16'h1234;
            repeat (2) @(posedge bclk);

            #1;


            check_outputs(16'h0000, 8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(posedge bclk);
            cs = 2'b01;
            rw = 0;
            din = 16'hBEEF;
            hi_addr = 3'b111;
            lba = 1;
            repeat (2) @(posedge bclk);

            #1;


            check_outputs(16'h0000, 8'hEF, 1'b1);
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
        input [15:0] expected_dout;
        input [7:0] expected_nram_dout;
        input expected_rb_wait;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_nram_dout === (expected_nram_dout ^ nram_dout ^ expected_nram_dout) &&
                expected_rb_wait === (expected_rb_wait ^ rb_wait ^ expected_rb_wait)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, nram_dout=%h, rb_wait=%b",
                         dout, nram_dout, rb_wait);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, nram_dout=%h, rb_wait=%b",
                         expected_dout, expected_nram_dout, expected_rb_wait);
                $display("  Got:      dout=%h, nram_dout=%h, rb_wait=%b",
                         dout, nram_dout, rb_wait);
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
        $dumpvars(0,bclk, clk, cs, din, hi_addr, lba, nram_a, nram_clk, nram_din, nram_we, oe, reset, rw, dout, nram_dout, rb_wait);
    end

endmodule

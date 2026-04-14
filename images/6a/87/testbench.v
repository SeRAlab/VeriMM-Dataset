`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg [7:0] din;
    reg nrst;
    reg [3:0] nsin;
    reg [3:0] nsout;
    reg rd;
    reg reset;
    reg wr;
    wire [7:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .din(din),
        .nrst(nrst),
        .nsin(nsin),
        .nsout(nsout),
        .rd(rd),
        .reset(reset),
        .wr(wr),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            nrst = 0;
            reset = 1;
            rd = 0;
            wr = 0;
            din = 0;
            nsin = 0;
            @(posedge clk);
            #1;
            nrst = 1;
            reset = 0;
            ce = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Check...");
            reset_dut();


            #1;



            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write and Read...");
            reset_dut();


            wr = 1; din = 8'hAB;
            @(posedge clk); #1;
            wr = 0;


            rd = 1;
            @(posedge clk); #1;
            rd = 0;


            #1;



            check_outputs(8'hAB, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Fill to Full...");
            reset_dut();



            wr = 1;
            for(i=0; i<16; i=i+1) begin
                din = i;
                @(posedge clk); #1;
                if (full) i = 16;
            end
            wr = 0;


            #1;



            check_outputs(8'hXX, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Fill then Empty...");
            reset_dut();


            wr = 1;
            for(i=1; i<=4; i=i+1) begin
                din = i;
                @(posedge clk); #1;
            end
            wr = 0;


            rd = 1;
            for(i=1; i<=4; i=i+1) begin
                @(posedge clk); #1;
            end
            rd = 0;


            #1;



            check_outputs(8'h04, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Simultaneous Read/Write...");
            reset_dut();


            wr = 1; din = 8'h11;
            @(posedge clk); #1;


            wr = 1; din = 8'h22;
            rd = 1;
            @(posedge clk); #1;
            wr = 0; rd = 0;


            #1;



            check_outputs(8'h11, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset mid-operation...");
            reset_dut();


            wr = 1; din = 8'h55; @(posedge clk); #1;
            din = 8'h66; @(posedge clk); #1;
            wr = 0;


            reset = 1;
            @(posedge clk); #1;
            reset = 0;


            #1;



            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Data Integrity...");
            reset_dut();


            wr = 1; din = 8'hAA; @(posedge clk); #1;
            wr = 1; din = 8'hBB; @(posedge clk); #1;
            wr = 0;

            rd = 1; @(posedge clk); #1;
            rd = 1; @(posedge clk); #1;
            rd = 0;

            #1;


            check_outputs(8'hBB, 1'b1, 1'b0);
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
        input [7:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b",
                         dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b",
                         expected_dout, expected_empty, expected_full);
                $display("  Got:      dout=%h, empty=%b, full=%b",
                         dout, empty, full);
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
        $dumpvars(0,ce, clk, din, nrst, nsin, nsout, rd, reset, wr, dout, empty, full);
    end

endmodule

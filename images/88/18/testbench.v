`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg nrst;
    reg rd;
    reg reset;
    reg [7:0] wdata;
    reg wr;
    wire empty;
    wire full;
    wire half_full;
    wire [7:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .nrst(nrst),
        .rd(rd),
        .reset(reset),
        .wdata(wdata),
        .wr(wr),
        .empty(empty),
        .full(full),
        .half_full(half_full),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 1;
            nrst = 0;
            reset = 1;
            wr = 0;
            rd = 0;
            wdata = 0;
            repeat(2) @(posedge clk);
            nrst = 1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            wr = 1; wdata = 8'hA5;
            @(posedge clk);
            wr = 0;
            @(posedge clk);

            rd = 1;
            @(posedge clk);
            rd = 0;
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                wr = 1; wdata = i;
                @(posedge clk);
            end
            wr = 0;
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 8'h00);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            for (i = 0; i < 4; i = i + 1) begin
                wr = 1; wdata = 8'hAA;
                @(posedge clk);
            end
            wr = 0;
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ce = 0;
            wr = 1; wdata = 8'h55;
            @(posedge clk);
            wr = 0;
            ce = 1;
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            wr = 1; wdata = 8'hEE;
            @(posedge clk);
            wr = 0;

            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            wr = 1; wdata = 8'h11; @(posedge clk);

            wr = 1; wdata = 8'h22; @(posedge clk);
            wr = 0;

            rd = 1; @(posedge clk);

            rd = 1; @(posedge clk);
            rd = 0;
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 8'h22);
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
        input expected_empty;
        input expected_full;
        input expected_half_full;
        input [7:0] expected_rdata;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_half_full === (expected_half_full ^ half_full ^ expected_half_full) &&
                expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, half_full=%b, rdata=%h",
                         empty, full, half_full, rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, half_full=%b, rdata=%h",
                         expected_empty, expected_full, expected_half_full, expected_rdata);
                $display("  Got:      empty=%b, full=%b, half_full=%b, rdata=%h",
                         empty, full, half_full, rdata);
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
        $dumpvars(0,ce, clk, nrst, rd, reset, wdata, wr, empty, full, half_full, rdata);
    end

endmodule

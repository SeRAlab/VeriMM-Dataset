`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg nrst;
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
        .clk(clk),
        .din(din),
        .nrst(nrst),
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
            nrst = 0;
            reset = 1;
            wr = 0;
            rd = 0;
            din = 0;
            repeat(2) @(posedge clk);
            #1;
            nrst = 1;
            reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write", test_num);
            reset_dut();
            din = 8'hA5;
            wr = 1;
            @(posedge clk);
            #1;
            wr = 0;
            #1;

            check_outputs(8'hxx, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Single Write/Read Data Integrity", test_num);
            reset_dut();

            din = 8'h5A;
            wr = 1; @(posedge clk); #1; wr = 0;

            rd = 1; @(posedge clk); #1; rd = 0;
            #1;

            check_outputs(8'h5A, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Filling FIFO to Full", test_num);
            reset_dut();
            wr = 1;
            for (i = 0; i < 256; i = i + 1) begin
                din = i[7:0];
                @(posedge clk);
            end
            #1;
            wr = 0;
            #1;

            check_outputs(8'hxx, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Full then Drain to Empty", test_num);
            reset_dut();

            wr = 1;
            for (i = 0; i < 256; i = i + 1) begin
                din = i[7:0];
                @(posedge clk);
            end
            #1; wr = 0;

            rd = 1;
            for (i = 0; i < 256; i = i + 1) begin
                @(posedge clk);
            end
            #1; rd = 0;

            #1;


            check_outputs(8'd255, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %03d: Pointer Wrap-around logic", test_num);
            reset_dut();

            wr = 1; din = 8'hFF; repeat(100) @(posedge clk); #1; wr = 0;
            rd = 1; repeat(100) @(posedge clk); #1; rd = 0;

            wr = 1;
            for (i = 0; i < 256; i = i + 1) begin
                din = i[7:0];
                @(posedge clk);
            end
            #1; wr = 0;
            #1;

            check_outputs(8'hxx, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Simultaneous Write and Read", test_num);
            reset_dut();

            din = 8'h11; wr = 1; @(posedge clk); #1; wr = 0;

            din = 8'h22; wr = 1; rd = 1; @(posedge clk); #1;
            wr = 0; rd = 0;

            #1;


            check_outputs(8'h11, 1'b0, 1'b0);
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
        $dumpvars(0,clk, din, nrst, rd, reset, wr, dout, empty, full);
    end

endmodule

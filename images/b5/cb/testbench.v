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
            repeat(2) @(negedge clk);
            nrst = 1;
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset state check");
            reset_dut();

            #1;


            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write and Read");
            reset_dut();


            wr = 1; din = 8'hA5;
            @(negedge clk);
            wr = 0;


            rd = 1;
            @(negedge clk);
            rd = 0;


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Fill FIFO to Full");
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                wr = 1; din = i;
                @(negedge clk);
            end
            wr = 0;


            #1;



            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Fill then Empty");
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                wr = 1; din = i;
                @(negedge clk);
            end
            wr = 0;


            rd = 1;
            for (i = 0; i < 7; i = i + 1) begin
                @(negedge clk);
            end

            @(negedge clk);
            rd = 0;


            #1;



            check_outputs(8'd7, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Overflow Check");
            reset_dut();


            wr = 1;
            for (i = 0; i < 10; i = i + 1) begin
                din = i;
                @(negedge clk);
            end
            wr = 0;


            #1;



            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Underflow Check");
            reset_dut();


            rd = 1;
            repeat(2) @(negedge clk);
            rd = 0;


            #1;



            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Simultaneous Write and Read");
            reset_dut();


            wr = 1; din = 8'h11;
            @(negedge clk);
            wr = 0;


            wr = 1; din = 8'h22;
            rd = 1;
            @(negedge clk);
            wr = 0; rd = 0;


            #1;



            check_outputs(8'h11, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Data Integrity Check");
            reset_dut();


            wr = 1; din = 8'hAA; @(negedge clk);
            wr = 1; din = 8'hBB; @(negedge clk);
            wr = 0;


            rd = 1; @(negedge clk);

            rd = 1; @(negedge clk);
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
        testcase008();
        
        
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

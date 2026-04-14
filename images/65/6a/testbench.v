`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] din;
    reg rd_clk;
    reg reset;
    reg wr_clk;
    wire [31:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .rd_clk(rd_clk),
        .reset(reset),
        .wr_clk(wr_clk),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            wr_clk_en = 0;
            rd_clk_en = 0;
            reset = 1;
            din = 0;
            #50;
            reset = 0;
            #50;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase 001: Initial State after Reset");
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase 002: Single Write Operation");
            reset_dut();

            din = 32'hDEADBEEF;
            wr_clk_en = 1;
            @(posedge wr_clk);
            #1;
            wr_clk_en = 0;


            #100;



            if (empty === 1'b0 && full === 1'b0) begin
                $display("PASS: Data written, empty flag de-asserted.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Flags did not update correctly after write.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase 003: Filling FIFO to Capacity (2048 items)");
            reset_dut();

            wr_clk_en = 1;
            rd_clk_en = 0;

            for (i = 0; i < 2048; i = i + 1) begin
                din = i;
                @(posedge wr_clk);
            end

            wr_clk_en = 0;
            #200;


            #1;



            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        reg [31:0] captured_dout;
        reg success;
        begin
            test_num = test_num + 1;
            $display("Testcase 004: Data Integrity (Write 5, Read 5)");
            reset_dut();
            success = 1;


            wr_clk_en = 1;
            for (i = 1; i <= 5; i = i + 1) begin
                din = i * 11;
                @(posedge wr_clk);
            end
            wr_clk_en = 0;
            #100;


            rd_clk_en = 1;
            for (i = 1; i <= 5; i = i + 1) begin
                @(posedge rd_clk);
                #1;
                if (dout !== i * 11) begin
                    $display("  Data mismatch at index %0d: Expected %h, Got %h", i, i*11, dout);
                    success = 0;
                end
            end
            rd_clk_en = 0;
            #100;

            if (success && empty === 1'b1) begin
                $display("PASS: Data matches and FIFO is empty");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Data mismatch or FIFO not empty");
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_dout;
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
        $dumpvars(0,din, rd_clk, reset, wr_clk, dout, empty, full);
    end

endmodule

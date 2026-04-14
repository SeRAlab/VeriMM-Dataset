`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rst_n;
    reg we;
    wire [7:0] dout;
    wire empty;
    wire full;
    wire re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rst_n(rst_n),
        .we(we),
        .dout(dout),
        .empty(empty),
        .full(full),
        .re(re)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            we = 0;
            din = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial Reset State...");
            reset_dut();


            #1;



            check_outputs(8'h00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Write Operation...");
            reset_dut();
            we = 1;
            din = 8'hA5;
            @(posedge clk);
            #1 we = 0; din = 0;
            #1;



            #1;




            check_outputs(dout, 1'b0, 1'b0, re);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running Testcase 003: Fill FIFO to Capacity...");
            reset_dut();
            we = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i + 8'h10;
                @(posedge clk);
            end
            #1 we = 0;
            #1;

            #1;


            check_outputs(dout, 1'b0, 1'b1, re);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running Testcase 004: Overflow Stability...");
            reset_dut();
            we = 1;

            for (i = 0; i < 20; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            #1 we = 0;
            #1;

            #1;


            check_outputs(dout, 1'b0, 1'b1, re);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running Testcase 005: Partial Fill (Half-Full)...");
            reset_dut();
            we = 1;

            for (i = 0; i < 8; i = i + 1) begin
                din = 8'hFF;
                @(posedge clk);
            end
            #1 we = 0;
            #1;

            #1;


            check_outputs(dout, 1'b0, 1'b0, re);
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
        input [7:0] expected_dout;
        input expected_empty;
        input expected_full;
        input expected_re;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_re === (expected_re ^ re ^ expected_re)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b, re=%b",
                         dout, empty, full, re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b, re=%b",
                         expected_dout, expected_empty, expected_full, expected_re);
                $display("  Got:      dout=%h, empty=%b, full=%b, re=%b",
                         dout, empty, full, re);
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
        $dumpvars(0,clk, din, rst_n, we, dout, empty, full, re);
    end

endmodule

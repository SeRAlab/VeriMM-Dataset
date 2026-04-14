`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [7:0] din;
    reg re;
    reg rst_n;
    reg we;
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
        .clr(clr),
        .din(din),
        .re(re),
        .rst_n(rst_n),
        .we(we),
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
            rst_n = 1'b0;
            clr = 1'b0;
            we = 1'b0;
            re = 1'b0;
            din = 8'h0;
            @(posedge clk);
            #1;
            rst_n = 1'b1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write/Read");
            reset_dut();

            we = 1'b1; din = 8'hA5;
            @(posedge clk);
            #1;
            we = 1'b0;

            re = 1'b1;
            @(posedge clk);
            #1;
            re = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Fill FIFO to Full");
            reset_dut();
            we = 1'b1;
            din = 8'h11; @(posedge clk); #1;
            din = 8'h22; @(posedge clk); #1;
            din = 8'h33; @(posedge clk); #1;
            din = 8'h44; @(posedge clk); #1;
            we = 1'b0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Fill and Empty FIFO");
            reset_dut();

            we = 1'b1;
            din = 8'h01; @(posedge clk); #1;
            din = 8'h02; @(posedge clk); #1;
            din = 8'h03; @(posedge clk); #1;
            din = 8'h04; @(posedge clk); #1;
            we = 1'b0;

            re = 1'b1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            re = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h04, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Clear Signal");
            reset_dut();

            we = 1'b1; din = 8'hCC; @(posedge clk); #1;
            din = 8'hDD; @(posedge clk); #1;
            we = 1'b0;

            clr = 1'b1;
            @(posedge clk);
            #1;
            clr = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Wrap-around logic");
            reset_dut();

            we = 1'b1; din = 8'h10; @(posedge clk); #1;
            din = 8'h20; @(posedge clk); #1;
            we = 1'b0; re = 1'b1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            re = 1'b0;

            we = 1'b1;
            din = 8'hAA; @(posedge clk); #1;
            din = 8'hBB; @(posedge clk); #1;
            din = 8'hCC; @(posedge clk); #1;
            din = 8'hDD; @(posedge clk); #1;
            we = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(dout, 1'b0, 1'b1);
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
        $dumpvars(0,clk, clr, din, re, rst_n, we, dout, empty, full);
    end

endmodule

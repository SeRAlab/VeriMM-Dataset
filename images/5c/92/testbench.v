`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] din;
    reg reset;
    wire davail;
    wire [3:0] dout;
    wire roc_hdr;
    wire tbm_hdr;
    wire tbm_trl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .reset(reset),
        .davail(davail),
        .dout(dout),
        .roc_hdr(roc_hdr),
        .tbm_hdr(tbm_hdr),
        .tbm_trl(tbm_trl)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            din = 2'b00;
            @(posedge clk);
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset and Idle Check...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 4'h0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: TBM Header Detection...");
            test_num = 2;
            reset_dut();
            @(posedge clk) din = 2'b01;
            @(posedge clk) din = 2'b11;
            @(posedge clk) din = 2'b11;
            @(posedge clk) din = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 4'b1101, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: ROC Header Detection...");
            test_num = 3;
            reset_dut();
            @(posedge clk) din = 2'b01;
            @(posedge clk) din = 2'b11;
            @(posedge clk) din = 2'b11;
            @(posedge clk) din = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 4'b1100, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: TBM Trailer Detection...");
            test_num = 4;
            reset_dut();
            @(posedge clk) din = 2'b01;
            @(posedge clk) din = 2'b11;
            @(posedge clk) din = 2'b11;
            @(posedge clk) din = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 4'b1111, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Normal Data Sequence...");
            test_num = 5;
            reset_dut();
            @(posedge clk) din = 2'b10;
            @(posedge clk) din = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 4'b1001, 0, 0, 0);
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
        input expected_davail;
        input [3:0] expected_dout;
        input expected_roc_hdr;
        input expected_tbm_hdr;
        input expected_tbm_trl;
        begin
            if (expected_davail === (expected_davail ^ davail ^ expected_davail) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_roc_hdr === (expected_roc_hdr ^ roc_hdr ^ expected_roc_hdr) &&
                expected_tbm_hdr === (expected_tbm_hdr ^ tbm_hdr ^ expected_tbm_hdr) &&
                expected_tbm_trl === (expected_tbm_trl ^ tbm_trl ^ expected_tbm_trl)) begin
                $display("PASS");
                $display("  Outputs: davail=%b, dout=%h, roc_hdr=%b, tbm_hdr=%b, tbm_trl=%b",
                         davail, dout, roc_hdr, tbm_hdr, tbm_trl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: davail=%b, dout=%h, roc_hdr=%b, tbm_hdr=%b, tbm_trl=%b",
                         expected_davail, expected_dout, expected_roc_hdr, expected_tbm_hdr, expected_tbm_trl);
                $display("  Got:      davail=%b, dout=%h, roc_hdr=%b, tbm_hdr=%b, tbm_trl=%b",
                         davail, dout, roc_hdr, tbm_hdr, tbm_trl);
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
        $dumpvars(0,clk, din, reset, davail, dout, roc_hdr, tbm_hdr, tbm_trl);
    end

endmodule

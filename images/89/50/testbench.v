`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clken;
    reg [3:0] in;
    reg rstn;
    wire [3:0] ff_out;
    wire [3:0] fg_out;
    wire [3:0] fh_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clken(clken),
        .in(in),
        .rstn(rstn),
        .ff_out(ff_out),
        .fg_out(fg_out),
        .fh_out(fh_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            clken = 0;
            in = 4'h0;
            repeat(2) @(posedge clk);
            #1 rstn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Reset State Verification", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Single Cycle Propagation", test_num);
            reset_dut();
            clken = 1;
            in = 4'hA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Two Cycle Propagation", test_num);
            reset_dut();
            clken = 1;
            in = 4'h5; @(posedge clk);
            #1 in = 4'hB; @(posedge clk);
            #2;
            #1;

            check_outputs(4'hB, 4'h5, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Full Pipeline Propagation", test_num);
            reset_dut();
            clken = 1;
            in = 4'h1; @(posedge clk);
            #1 in = 4'h2; @(posedge clk);
            #1 in = 4'h3; @(posedge clk);
            #2;
            #1;

            check_outputs(4'h3, 4'h2, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Clock Enable Check", test_num);
            reset_dut();
            clken = 1;
            in = 4'hF; @(posedge clk);
            #1 clken = 0;
            in = 4'hE; @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Mid-stream Reset Check", test_num);
            reset_dut();
            clken = 1;
            in = 4'h7; @(posedge clk);
            #1 in = 4'h8; @(posedge clk);
            #1 rstn = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0);
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
        input [3:0] expected_ff_out;
        input [3:0] expected_fg_out;
        input [3:0] expected_fh_out;
        begin
            if (expected_ff_out === (expected_ff_out ^ ff_out ^ expected_ff_out) &&
                expected_fg_out === (expected_fg_out ^ fg_out ^ expected_fg_out) &&
                expected_fh_out === (expected_fh_out ^ fh_out ^ expected_fh_out)) begin
                $display("PASS");
                $display("  Outputs: ff_out=%h, fg_out=%h, fh_out=%h",
                         ff_out, fg_out, fh_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ff_out=%h, fg_out=%h, fh_out=%h",
                         expected_ff_out, expected_fg_out, expected_fh_out);
                $display("  Got:      ff_out=%h, fg_out=%h, fh_out=%h",
                         ff_out, fg_out, fh_out);
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
        $dumpvars(0,clk, clken, in, rstn, ff_out, fg_out, fh_out);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] ra;
    reg rce;
    reg [10:0] wa;
    reg wce;
    reg [7:0] wd;
    wire [7:0] rq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ra(ra),
        .rce(rce),
        .wa(wa),
        .wce(wce),
        .wd(wd),
        .rq(rq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rce = 0;
            wce = 0;
            ra = 0;
            wa = 0;
            wd = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            reset_dut();

            @(posedge clk);
            wa <= 11'h010;
            wd <= 8'hAA;
            wce <= 1;
            @(posedge clk);
            wce <= 0;

            ra <= 11'h010;
            rce <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Multiple Writes followed by Read");
            reset_dut();

            @(posedge clk);
            wa <= 11'h005; wd <= 8'h55; wce <= 1;
            @(posedge clk);

            wa <= 11'h7FF; wd <= 8'hFF; wce <= 1;
            @(posedge clk);
            wce <= 0;

            ra <= 11'h7FF; rce <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Read Enable (rce) control check");
            reset_dut();

            @(posedge clk);
            wa <= 11'h100; wd <= 8'h12; wce <= 1;
            @(posedge clk);
            wce <= 0;

            ra <= 11'h100; rce <= 0;
            @(posedge clk);
            #1;

            if (rq !== 8'h12) begin
                $display("PASS: rq did not update because rce was low.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: rq updated despite rce being low.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Simultaneous Read and Write");
            reset_dut();

            @(posedge clk);
            wa <= 11'h020; wd <= 8'h20; wce <= 1;
            @(posedge clk);

            wa <= 11'h030; wd <= 8'h30; wce <= 1;
            ra <= 11'h020; rce <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting a memory location");
            reset_dut();

            @(posedge clk);
            wa <= 11'h050; wd <= 8'hA1; wce <= 1;
            @(posedge clk);

            wa <= 11'h050; wd <= 8'hB2; wce <= 1;
            @(posedge clk);
            wce <= 0;
            ra <= 11'h050; rce <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hB2);
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
        input [7:0] expected_rq;
        begin
            if (expected_rq === (expected_rq ^ rq ^ expected_rq)) begin
                $display("PASS");
                $display("  Outputs: rq=%h",
                         rq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rq=%h",
                         expected_rq);
                $display("  Got:      rq=%h",
                         rq);
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
        $dumpvars(0,clk, ra, rce, wa, wce, wd, rq);
    end

endmodule

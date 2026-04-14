`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] d;
    wire [127:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 128'b0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: All Ones...");
            reset_dut();
            d = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Alternating Bits A...");
            reset_dut();
            d = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Alternating Bits 5...");
            reset_dut();
            d = 128'h55555555555555555555555555555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h55555555555555555555555555555555);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Hex Pattern...");
            reset_dut();
            d = 128'h1234567890ABCDEF1234567890ABCDEF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h1234567890ABCDEF1234567890ABCDEF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Capture Zero...");

            d = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2;

            d = 128'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Stability Check...");
            reset_dut();
            d = 128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA;
            #2;
            d = 128'hBBBB_BBBB_BBBB_BBBB_BBBB_BBBB_BBBB_BBBB;
            #2;
            d = 128'hCCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hCCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC);
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
        input [127:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, q);
    end

endmodule

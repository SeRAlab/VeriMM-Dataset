`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr0;
    reg ce0;
    reg clk;
    reg [63:0] d0;
    reg we0;
    wire [63:0] q0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .ce0(ce0),
        .clk(clk),
        .d0(d0),
        .we0(we0),
        .q0(q0)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce0 = 0;
            we0 = 0;
            addr0 = 0;
            d0 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            ce0 = 1; we0 = 1; addr0 = 4'h4; d0 = 64'h123456789ABCDEF0;
            @(posedge clk); #1;

            we0 = 0; addr0 = 4'h4;
            @(posedge clk); #1;
            #1;

            check_outputs(64'h123456789ABCDEF0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            ce0 = 0; we0 = 1; addr0 = 4'hA; d0 = 64'hDEADBEEFDEADBEEF;
            @(posedge clk); #1;

            ce0 = 1; we0 = 0; addr0 = 4'hA;
            @(posedge clk); #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            ce0 = 1; we0 = 1; addr0 = 4'hF; d0 = 64'hAAAAAAAAAAAAAAAA;
            @(posedge clk); #1;

            d0 = 64'h5555555555555555;
            @(posedge clk); #1;

            we0 = 0; addr0 = 4'hF;
            @(posedge clk); #1;
            #1;

            check_outputs(64'h5555555555555555);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            ce0 = 1; we0 = 1; addr0 = 4'h1; d0 = 64'h0123456789ABCDEF;
            @(posedge clk); #1;

            we0 = 0; d0 = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk); #1;

            addr0 = 4'h1;
            @(posedge clk); #1;
            #1;

            check_outputs(64'h0123456789ABCDEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            ce0 = 1; we0 = 1; addr0 = 4'h0; d0 = 64'hB007B007B007B007;
            @(posedge clk); #1;

            addr0 = 4'hF; d0 = 64'hF00DF00DF00DF00D;
            @(posedge clk); #1;

            we0 = 0; addr0 = 4'h0;
            @(posedge clk); #1;
            #1;

            check_outputs(64'hB007B007B007B007);
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
        input [63:0] expected_q0;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0)) begin
                $display("PASS");
                $display("  Outputs: q0=%h",
                         q0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h",
                         expected_q0);
                $display("  Got:      q0=%h",
                         q0);
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
        $dumpvars(0,addr0, ce0, clk, d0, we0, q0);
    end

endmodule

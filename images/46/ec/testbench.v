`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg enable;
    reg reset;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            d = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Synchronous Reset Check");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Loading Data (Enable=1)");
            reset_dut();
            @(negedge clk);
            enable = 1;
            d = 16'hABCD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Data Retention (Enable=0)");
            reset_dut();


            @(negedge clk);
            enable = 1;
            d = 16'h1234;
            @(posedge clk);
            #1;


            @(negedge clk);
            enable = 0;
            d = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Reset Priority Over Enable");
            reset_dut();


            @(negedge clk);
            enable = 1;
            d = 16'h5555;
            @(posedge clk);
            #1;


            @(negedge clk);
            reset = 1;
            enable = 1;
            d = 16'hAAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Consecutive Data Loads");
            reset_dut();

            @(negedge clk);
            enable = 1;
            d = 16'h1111;
            @(posedge clk);
            #1;

            @(negedge clk);
            d = 16'h2222;
            @(posedge clk);
            #1;

            @(negedge clk);
            d = 16'h3333;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h3333);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset from Non-Zero State");
            reset_dut();


            @(negedge clk);
            enable = 1;
            d = 16'hDEAD;
            @(posedge clk);
            #1;


            @(negedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, d, enable, reset, q);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [31:0] d;
    reg enable;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .d(d),
        .enable(enable),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            clear <= 1;
            enable <= 0;
            d <= 32'h0;
            @(posedge clk);
            clear <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Data Loading", test_num);
            reset_dut();
            @(posedge clk);
            enable <= 1;
            d <= 32'hA5A5A5A5;
            @(posedge clk);
            enable <= 0;
            #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Enable=0 (Hold previous value)", test_num);
            reset_dut();

            @(posedge clk);
            enable <= 1;
            d <= 32'h11223344;
            @(posedge clk);

            enable <= 0;
            d <= 32'hFFEECCBB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h11223344);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Clear", test_num);
            reset_dut();

            @(posedge clk);
            enable <= 1;
            d <= 32'hFFFFFFFF;
            @(posedge clk);

            clear <= 1;
            enable <= 0;
            @(posedge clk);
            clear <= 0;
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Clear Priority over Enable", test_num);
            reset_dut();
            @(posedge clk);
            enable <= 1;
            clear <= 1;
            d <= 32'hCAFEFACE;
            @(posedge clk);
            clear <= 0;
            enable <= 0;
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive Data Loads", test_num);
            reset_dut();
            @(posedge clk);
            enable <= 1;
            d <= 32'h1;
            @(posedge clk);
            d <= 32'h2;
            @(posedge clk);
            d <= 32'h3;
            @(posedge clk);
            enable <= 0;
            #1;
            #1;

            check_outputs(32'h3);
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
        input [31:0] expected_q;
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
        $dumpvars(0,clear, clk, d, enable, q);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] d;
    reg enable;
    reg reset;
    wire [23:0] q;

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
            @(posedge clk);
            #1;
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
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Reset", test_num);
            reset_dut();

            #1;


            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load data with enable high", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            enable = 1;
            d = 24'hABCDEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'hABCDEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold data with enable low", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            enable = 1;
            d = 24'h123456;
            @(posedge clk);
            #1;

            enable = 0;
            d = 24'hFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'h123456);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset priority over enable", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            reset = 1;
            enable = 1;
            d = 24'h555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load full scale (0xFFFFFF)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            enable = 1;
            d = 24'hFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple consecutive loads", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            enable = 1;
            d = 24'hAAAAAA;
            @(posedge clk);
            #1;
            d = 24'h555555;
            @(posedge clk);
            #1;
            d = 24'h0F0F0F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'h0F0F0F);
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
        input [23:0] expected_q;
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

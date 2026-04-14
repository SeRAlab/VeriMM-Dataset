`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] cfg;
    reg clk;
    reg res;
    wire clk_cog;
    wire clk_pll;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cfg(cfg),
        .clk(clk),
        .res(res),
        .clk_cog(clk_cog),
        .clk_pll(clk_pll)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            res = 1;
            cfg = 7'b0;
            repeat(3) @(posedge clk);
            #2 res = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Default Config (0x00)", test_num);
            reset_dut();
            cfg = 7'h00;
            repeat(10) @(posedge clk);

            @(negedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Bypass Mode (clksel=0)", test_num);
            reset_dut();
            cfg = 7'b0001010;
            repeat(15) @(posedge clk);
            @(negedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Divided Mode (clksel=1)", test_num);
            reset_dut();
            cfg = 7'b1000010;
            repeat(20) @(posedge clk);
            @(negedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Max Config (0x7F)", test_num);
            reset_dut();
            cfg = 7'h7F;
            repeat(50) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Dynamic Update", test_num);
            reset_dut();
            cfg = 7'h20;
            repeat(5) @(posedge clk);
            cfg = 7'h45;
            repeat(15) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_clk_cog;
        input expected_clk_pll;
        begin
            if (expected_clk_cog === (expected_clk_cog ^ clk_cog ^ expected_clk_cog) &&
                expected_clk_pll === (expected_clk_pll ^ clk_pll ^ expected_clk_pll)) begin
                $display("PASS");
                $display("  Outputs: clk_cog=%b, clk_pll=%b",
                         clk_cog, clk_pll);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_cog=%b, clk_pll=%b",
                         expected_clk_cog, expected_clk_pll);
                $display("  Got:      clk_cog=%b, clk_pll=%b",
                         clk_cog, clk_pll);
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
        $dumpvars(0,cfg, clk, res, clk_cog, clk_pll);
    end

endmodule

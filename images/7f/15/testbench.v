`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_en;
    reg src_clk;
    wire gated_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_en(clk_en),
        .src_clk(src_clk),
        .gated_clk(gated_clk)
    );

    // Clock generation (10ns period)
    initial begin
        src_clk = 0;
        forever #5 src_clk = ~src_clk;
    end

        task reset_dut;

        begin
            clk_en <= 0;
            @(posedge src_clk);
            @(negedge src_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Clock Gated (Enable = 0)", test_num);
            reset_dut();

            @(posedge src_clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Clock Active (Enable = 1)", test_num);
            reset_dut();
            @(negedge src_clk);
            clk_en <= 1;
            @(posedge src_clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Disable Transition", test_num);
            reset_dut();

            @(negedge src_clk);
            clk_en <= 1;
            @(posedge src_clk);

            @(negedge src_clk);
            clk_en <= 0;
            @(posedge src_clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Gated Clock Low Phase", test_num);
            reset_dut();
            @(negedge src_clk);
            clk_en <= 1;
            @(posedge src_clk);
            @(negedge src_clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Glitch Immunity on Enable", test_num);
            reset_dut();
            @(negedge src_clk);
            clk_en <= 1;
            #2;
            clk_en <= 0;
            @(posedge src_clk);
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_gated_clk;
        begin
            if (expected_gated_clk === (expected_gated_clk ^ gated_clk ^ expected_gated_clk)) begin
                $display("PASS");
                $display("  Outputs: gated_clk=%b",
                         gated_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gated_clk=%b",
                         expected_gated_clk);
                $display("  Got:      gated_clk=%b",
                         gated_clk);
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
        $dumpvars(0,clk_en, src_clk, gated_clk);
    end

endmodule

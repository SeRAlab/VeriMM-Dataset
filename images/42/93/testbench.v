`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire sinhr;
    wire upr_gen;
    wire upr_mod;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sinhr(sinhr),
        .upr_gen(upr_gen),
        .upr_mod(upr_mod)
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
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Checking initial state (Cycle 0)", test_num);


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Checking state at mid-interval (Cycle 5000)", test_num);
            repeat(5000) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Checking state at late-interval (Cycle 12000)", test_num);
            repeat(12000) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Checking state at the end of the sequence (Cycle 14999)", test_num);
            repeat(14999) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Verifying sequence reset/wraparound (Cycle 15000)", test_num);
            repeat(15000) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_sinhr;
        input expected_upr_gen;
        input expected_upr_mod;
        begin
            if (expected_sinhr === (expected_sinhr ^ sinhr ^ expected_sinhr) &&
                expected_upr_gen === (expected_upr_gen ^ upr_gen ^ expected_upr_gen) &&
                expected_upr_mod === (expected_upr_mod ^ upr_mod ^ expected_upr_mod)) begin
                $display("PASS");
                $display("  Outputs: sinhr=%b, upr_gen=%b, upr_mod=%b",
                         sinhr, upr_gen, upr_mod);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sinhr=%b, upr_gen=%b, upr_mod=%b",
                         expected_sinhr, expected_upr_gen, expected_upr_mod);
                $display("  Got:      sinhr=%b, upr_gen=%b, upr_mod=%b",
                         sinhr, upr_gen, upr_mod);
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
        $dumpvars(0,clk, sinhr, upr_gen, upr_mod);
    end

endmodule

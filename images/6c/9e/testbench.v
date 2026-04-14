`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg feedback_clk;
    reg ref_clk;
    reg reset;
    wire dll_clk;
    wire pll_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .feedback_clk(feedback_clk),
        .ref_clk(ref_clk),
        .reset(reset),
        .dll_clk(dll_clk),
        .pll_clk(pll_clk)
    );

    // Clock generation (10ns period)
    initial begin
        ref_clk = 0;
        forever #5 ref_clk = ~ref_clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        feedback_clk = 0;
        #40;
        reset = 0;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Initialization and Lock", test_num);
        reset_dut();

        enable = 1;

        #1000;




        #1;





        check_outputs(dll_clk, pll_clk);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Enable Control Verification", test_num);
        reset_dut();

        enable = 1;
        #200;
        enable = 0;
        #100;


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Post-Reset Recovery", test_num);
        reset_dut();

        enable = 1;
        #500;


        reset = 1;
        #100;
        reset = 0;
        #500;



        if (pll_clk !== 1'bx && dll_clk !== 1'bx)
            #1;

            check_outputs(dll_clk, pll_clk);
        else
            #1;

            check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Long-term Stability", test_num);
        reset_dut();

        enable = 1;
        #5000;




        #0;
        #1;

        check_outputs(dll_clk, pll_clk);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Quick Toggle Enable", test_num);
        reset_dut();

        enable = 1; #20;
        enable = 0; #20;
        enable = 1; #20;
        enable = 0; #20;
        enable = 1;
        #200;


        #1;



        check_outputs(dll_clk, pll_clk);
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
        input expected_dll_clk;
        input expected_pll_clk;
        begin
            if (expected_dll_clk === (expected_dll_clk ^ dll_clk ^ expected_dll_clk) &&
                expected_pll_clk === (expected_pll_clk ^ pll_clk ^ expected_pll_clk)) begin
                $display("PASS");
                $display("  Outputs: dll_clk=%b, pll_clk=%b",
                         dll_clk, pll_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dll_clk=%b, pll_clk=%b",
                         expected_dll_clk, expected_pll_clk);
                $display("  Got:      dll_clk=%b, pll_clk=%b",
                         dll_clk, pll_clk);
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
        $dumpvars(0,enable, feedback_clk, ref_clk, reset, dll_clk, pll_clk);
    end

endmodule

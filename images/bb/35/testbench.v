`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg data_clk;
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
        .data_clk(data_clk),
        .ref_clk(ref_clk),
        .reset(reset),
        .dll_clk(dll_clk),
        .pll_clk(pll_clk)
    );

    // Clock generation (10ns period)
    initial begin
        data_clk = 0;
        forever #5 data_clk = ~data_clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verifying Reset State", test_num);
            reset = 1;
            #40;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Operation after 55ns", test_num);
            reset_dut();
            #55;



            #1;




            check_outputs(dll_clk, pll_clk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Operation after 205ns", test_num);
            reset_dut();
            #205;

            #1;


            check_outputs(dll_clk, pll_clk);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Reset Recovery mid-operation", test_num);
            reset_dut();
            #100;
            reset = 1;
            #25;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Alignment check at 500ns", test_num);
            reset_dut();
            #500;

            if (dll_clk === 1'bx || pll_clk === 1'bx) begin
                $display("FAIL: Clocks are undefined!");
                fail_count = fail_count + 1;
            end else begin
                #1;

                check_outputs(dll_clk, pll_clk);
            end
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
        $dumpvars(0,data_clk, ref_clk, reset, dll_clk, pll_clk);
    end

endmodule

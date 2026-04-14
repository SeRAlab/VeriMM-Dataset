`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_ena;
    reg [17:0] dataa;
    wire [17:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_ena(clk_ena),
        .dataa(dataa),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk_ena = 0;
            dataa = 0;
            wait_cycles(1);
        end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Load", test_num);
            clk_ena = 1;
            dataa = 18'h12345;
            wait_cycles(1);
            #1;

            check_outputs(18'h12345);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hold value when clk_ena=0", test_num);


            clk_ena = 1;
            dataa = 18'h0AAAA;
            wait_cycles(1);


            clk_ena = 0;
            dataa = 18'h3FFFF;
            wait_cycles(1);


            #1;



            check_outputs(18'h0AAAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Loading 18'h3FFFF", test_num);
            clk_ena = 1;
            dataa = 18'h3FFFF;
            wait_cycles(1);
            #1;

            check_outputs(18'h3FFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Loading 18'h00000", test_num);


            clk_ena = 1;
            dataa = 18'h3FFFF;
            wait_cycles(1);


            dataa = 18'h00000;
            wait_cycles(1);
            #1;

            check_outputs(18'h00000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern toggling with enable control", test_num);

            clk_ena = 1;
            dataa = 18'h25A5A;
            wait_cycles(1);

            clk_ena = 0;
            dataa = 18'h1A5A5;
            wait_cycles(2);

            clk_ena = 1;
            dataa = 18'h3C3C3;
            wait_cycles(1);

            #1;


            check_outputs(18'h3C3C3);
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
        input [17:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, clk_ena, dataa, result);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    wire clk_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_en(clk_en)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clock held LOW", test_num);
            clk = 0;
            #50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clock held HIGH", test_num);
            clk = 1;
            #50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clock toggling at 100MHz", test_num);
            for (i = 0; i < 20; i = i + 1) begin
                clk = 1;
                #5;
                clk = 0;
                #5;
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clock toggling at 250MHz", test_num);
            for (i = 0; i < 50; i = i + 1) begin
                clk = 1;
                #2;
                clk = 0;
                #2;
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Long duration stability check", test_num);
            clk = 0;
            #1000;
            #1;

            check_outputs(1'b1);
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
        input expected_clk_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk_en === (expected_clk_en ^ clk_en ^ expected_clk_en)) begin
                $display("PASS");
                $display("  Outputs: clk_en=%b",
                         clk_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_en=%b",
                         expected_clk_en);
                $display("  Got:      clk_en=%b",
                         clk_en);
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

endmodule

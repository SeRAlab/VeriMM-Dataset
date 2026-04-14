`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg clk;
    reg rst;
    wire Aout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .clk(clk),
        .rst(rst),
        .Aout(Aout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset and Initial State Check", test_num);
            rst = 1; A = 1;
            #20 rst = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A stable HIGH for 1,000,000 cycles", test_num);
            rst = 1; A = 0;
            #20 rst = 0;
            A = 1;

            for (i = 0; i < 1000000; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A stable HIGH for 500,000 cycles (Below Threshold)", test_num);
            rst = 1; A = 0;
            #20 rst = 0;
            A = 1;

            for (i = 0; i < 500000; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A transitions to LOW after threshold is reached", test_num);
            rst = 1; A = 0;
            #20 rst = 0;
            A = 1;
            for (i = 0; i < 1000000; i = i + 1) begin
                @(posedge clk);
            end

            A = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A stable LOW for 1,000,000 cycles", test_num);
            rst = 1; A = 1;
            #20 rst = 0;
            A = 0;
            for (i = 0; i < 1000000; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(0);
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
        input expected_Aout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Aout === (expected_Aout ^ Aout ^ expected_Aout)) begin
                $display("PASS");
                $display("  Outputs: Aout=%b",
                         Aout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Aout=%b",
                         expected_Aout);
                $display("  Got:      Aout=%b",
                         Aout);
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

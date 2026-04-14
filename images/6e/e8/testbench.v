`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    wire clk_out;
    wire pa_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_out(clk_out),
        .pa_en(pa_en)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Initial state check (clk=0)");

        clk = 0;

        #10;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Clock high state check (clk=1)");

        clk = 1;

        #10;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: verify pa_en remains LOW after clock transitions (ending LOW)");

        clk = 0; #5;
        clk = 1; #5;
        clk = 0; #5;
        clk = 1; #5;
        clk = 0; #10;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: verify pa_en remains LOW after clock transitions (ending HIGH)");

        clk = 0; #5;
        clk = 1; #5;
        clk = 0; #5;
        clk = 1; #10;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Long duration stability check");

        repeat(10) begin
            clk = ~clk;
            #10;
        end
        clk = 0;
        #50;

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
        input expected_clk_out;
        input expected_pa_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_pa_en === (expected_pa_en ^ pa_en ^ expected_pa_en)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, pa_en=%b",
                         clk_out, pa_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, pa_en=%b",
                         expected_clk_out, expected_pa_en);
                $display("  Got:      clk_out=%b, pa_en=%b",
                         clk_out, pa_en);
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

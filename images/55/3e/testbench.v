`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] num_in;
    wire [15:0] num_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num_in(num_in),
        .num_out(num_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Input 0");
        num_in = 16'sd0;
        #1;

        check_outputs(16'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Input 100");
        num_in = 16'sd100;
        #1;

        check_outputs(16'sd100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Input -100");
        num_in = -16'sd100;
        #1;

        check_outputs(16'sd100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Input 32767 (Max Positive)");
        num_in = 16'sh7FFF;
        #1;

        check_outputs(16'sh7FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Input -32768 (Min Negative)");
        num_in = 16'sh8000;
        #1;

        check_outputs(16'sh8000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Input -1");
        num_in = -16'sd1;
        #1;

        check_outputs(16'sd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Input -12345");
        num_in = -16'sd12345;
        #1;

        check_outputs(16'sd12345);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Input 25000");
        num_in = 16'sd25000;
        #1;

        check_outputs(16'sd25000);
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
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_num_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_num_out === (expected_num_out ^ num_out ^ expected_num_out)) begin
                $display("PASS");
                $display("  Outputs: num_out=%h",
                         num_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num_out=%h",
                         expected_num_out);
                $display("  Got:      num_out=%h",
                         num_out);
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

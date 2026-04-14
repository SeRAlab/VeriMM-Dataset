`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bit1;
    reg bit2;
    wire bit3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bit1(bit1),
        .bit2(bit2),
        .bit3(bit3)
    );
    task testcase001;

    begin
        $display("Test Case 001: bit1=0, bit2=0");
        test_num = 1;
        bit1 = 0;
        bit2 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: bit1=0, bit2=1");
        test_num = 2;
        bit1 = 0;
        bit2 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: bit1=1, bit2=0");
        test_num = 3;
        bit1 = 1;
        bit2 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: bit1=1, bit2=1");
        test_num = 4;
        bit1 = 1;
        bit2 = 1;
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
        input expected_bit3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bit3 === (expected_bit3 ^ bit3 ^ expected_bit3)) begin
                $display("PASS");
                $display("  Outputs: bit3=%b",
                         bit3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit3=%b",
                         expected_bit3);
                $display("  Got:      bit3=%b",
                         bit3);
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

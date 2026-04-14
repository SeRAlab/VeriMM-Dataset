`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a__2;
    reg b__2;
    wire n__10;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a__2(a__2),
        .b__2(b__2),
        .n__10(n__10)
    );
    task testcase001;

    begin
        test_num = 1;
        a__2 = 1'b0;
        b__2 = 1'b0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a__2 = 1'b0;
        b__2 = 1'b1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a__2 = 1'b1;
        b__2 = 1'b0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a__2 = 1'b1;
        b__2 = 1'b1;

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
        input expected_n__10;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n__10 === (expected_n__10 ^ n__10 ^ expected_n__10)) begin
                $display("PASS");
                $display("  Outputs: n__10=%b",
                         n__10);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n__10=%b",
                         expected_n__10);
                $display("  Got:      n__10=%b",
                         n__10);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i1;
    reg i2;
    wire o1;
    wire o2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i1(i1),
        .i2(i2),
        .o1(o1),
        .o2(o2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: i1=0, i2=0", test_num);
            i1 = 1'b0;
            i2 = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: i1=0, i2=1", test_num);
            i1 = 1'b0;
            i2 = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: i1=1, i2=0", test_num);
            i1 = 1'b1;
            i2 = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: i1=1, i2=1", test_num);
            i1 = 1'b1;
            i2 = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_o1;
        input expected_o2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2)) begin
                $display("PASS");
                $display("  Outputs: o1=%b, o2=%b",
                         o1, o2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o1=%b, o2=%b",
                         expected_o1, expected_o2);
                $display("  Got:      o1=%b, o2=%b",
                         o1, o2);
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

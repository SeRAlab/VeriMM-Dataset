`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg s1;
    wire s2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .r(r),
        .s1(s1),
        .s2(s2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs LOW (s1=0, r=0)", test_num);
            s1 = 1'b0;
            r  = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: s1 LOW, r HIGH (s1=0, r=1)", test_num);
            s1 = 1'b0;
            r  = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: s1 HIGH, r LOW (s1=1, r=0)", test_num);
            s1 = 1'b1;
            r  = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs HIGH (s1=1, r=1)", test_num);
            s1 = 1'b1;
            r  = 1'b1;
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
        input expected_s2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s2 === (expected_s2 ^ s2 ^ expected_s2)) begin
                $display("PASS");
                $display("  Outputs: s2=%b",
                         s2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s2=%b",
                         expected_s2);
                $display("  Got:      s2=%b",
                         s2);
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

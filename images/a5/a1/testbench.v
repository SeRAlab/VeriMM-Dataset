`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg e0;
    reg e1;
    wire s0;
    wire s1;
    wire s2;
    wire s3;
    wire s4;
    wire s5;
    wire s6;
    wire s7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e0(e0),
        .e1(e1),
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .s4(s4),
        .s5(s5),
        .s6(s6),
        .s7(s7)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: e0=0, e1=0", test_num);
            e0 = 0;
            e1 = 0;

            #1;


            check_outputs(0, 0, 0, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: e0=0, e1=1", test_num);
            e0 = 0;
            e1 = 1;

            #1;


            check_outputs(0, 1, 1, 1, 0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: e0=1, e1=0", test_num);
            e0 = 1;
            e1 = 0;

            #1;


            check_outputs(0, 1, 1, 1, 0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: e0=1, e1=1", test_num);
            e0 = 1;
            e1 = 1;

            #1;


            check_outputs(1, 1, 0, 0, 0, 1, 0, 1);
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
        input expected_s0;
        input expected_s1;
        input expected_s2;
        input expected_s3;
        input expected_s4;
        input expected_s5;
        input expected_s6;
        input expected_s7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s0 === (expected_s0 ^ s0 ^ expected_s0) &&
                expected_s1 === (expected_s1 ^ s1 ^ expected_s1) &&
                expected_s2 === (expected_s2 ^ s2 ^ expected_s2) &&
                expected_s3 === (expected_s3 ^ s3 ^ expected_s3) &&
                expected_s4 === (expected_s4 ^ s4 ^ expected_s4) &&
                expected_s5 === (expected_s5 ^ s5 ^ expected_s5) &&
                expected_s6 === (expected_s6 ^ s6 ^ expected_s6) &&
                expected_s7 === (expected_s7 ^ s7 ^ expected_s7)) begin
                $display("PASS");
                $display("  Outputs: s0=%b, s1=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b",
                         s0, s1, s2, s3, s4, s5, s6, s7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s0=%b, s1=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b",
                         expected_s0, expected_s1, expected_s2, expected_s3, expected_s4, expected_s5, expected_s6, expected_s7);
                $display("  Got:      s0=%b, s1=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b",
                         s0, s1, s2, s3, s4, s5, s6, s7);
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

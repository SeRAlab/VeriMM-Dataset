`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg C;
    reg CB;
    reg CE;
    reg D;
    reg R;
    reg S;
    wire Q1;
    wire Q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .CB(CB),
        .CE(CE),
        .D(D),
        .R(R),
        .S(S),
        .Q1(Q1),
        .Q2(Q2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Synchronous Reset Priority", test_num);

            R = 1; S = 1; CE = 1; D = 1; C = 0; CB = 0;
            #10 C = 1; #10 CB = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Synchronous Set Functionality", test_num);

            R = 1; S = 0; CE = 1; D = 0; C = 0; CB = 0;
            #10 C = 1; #10 CB = 1;

            #10 R = 0; S = 1; C = 0; CB = 0;
            #10 C = 1; #10 CB = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: DDR Data Sampling (D=1 at C, D=0 at CB)", test_num);

            R = 1; S = 0; CE = 1; D = 0; C = 0; CB = 0;
            #10 C = 1; #10 CB = 1;

            #10 R = 0; S = 0; CE = 1; D = 1; C = 0; CB = 0;
            #10 C = 1;
            #10 D = 0;
            #10 CB = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: DDR Data Sampling (D=0 at C, D=1 at CB)", test_num);

            R = 1; S = 0; CE = 1; D = 1; C = 0; CB = 0;
            #10 C = 1; #10 CB = 1;

            #10 R = 0; S = 0; CE = 1; D = 0; C = 0; CB = 0;
            #10 C = 1;
            #10 D = 1;
            #10 CB = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Clock Enable (CE) Inhibit", test_num);

            R = 1; S = 0; CE = 1; D = 0; C = 0; CB = 0;
            #10 C = 1; #10 CB = 1;

            #10 R = 0; S = 1; C = 0; CB = 0;
            #10 C = 1; #10 CB = 1;

            #10 R = 0; S = 0; CE = 0; D = 0; C = 0; CB = 0;
            #10 C = 1; #10 CB = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Recovery from Reset to Data", test_num);

            R = 1; S = 0; CE = 1; D = 1; C = 0; CB = 0;
            #10 C = 1; #10 CB = 1;

            #10 R = 0; S = 0; CE = 1; D = 1; C = 0; CB = 0;
            #10 C = 1; #10 CB = 1;
            #10;
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
        testcase005();
        testcase006();
        
        
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
        input expected_Q1;
        input expected_Q2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2)) begin
                $display("PASS");
                $display("  Outputs: Q1=%b, Q2=%b",
                         Q1, Q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q1=%b, Q2=%b",
                         expected_Q1, expected_Q2);
                $display("  Got:      Q1=%b, Q2=%b",
                         Q1, Q2);
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

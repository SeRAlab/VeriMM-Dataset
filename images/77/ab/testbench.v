`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg RN;
    reg SN;
    reg T;
    wire Q;
    wire QN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .RN(RN),
        .SN(SN),
        .T(T),
        .Q(Q),
        .QN(QN)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset (RN active low)", test_num);

            RN = 0; SN = 1; T = 0; D = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Asynchronous Set (SN active low)", test_num);

            RN = 0; SN = 1; T = 0; D = 0;
            #10;

            RN = 1; SN = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Priority Check (RN vs SN)", test_num);

            RN = 0; SN = 1; T = 0; D = 0;
            #10;

            RN = 0; SN = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Toggle from 0 to 1 (T=1 pulse)", test_num);

            RN = 0; SN = 1; T = 0; D = 0;
            #10;

            RN = 1; SN = 1;
            #5;
            T = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Toggle from 1 to 0", test_num);

            RN = 0; SN = 1; T = 0; D = 0;
            #10;

            RN = 1; SN = 0;
            #10;

            RN = 1; SN = 1; T = 0;
            #5;
            T = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Hold Value (T=0)", test_num);

            RN = 0; SN = 1; T = 0; D = 0;
            #10;

            RN = 1; SN = 1; T = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiple Toggles", test_num);

            RN = 0; SN = 1; T = 0; D = 0;
            #10;
            RN = 1; SN = 1;
            #5;

            T = 1; #10; T = 0; #10;

            T = 1; #10; T = 0; #10;

            T = 1; #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Asynchronous Override while T is High", test_num);

            RN = 0; SN = 1; T = 0; D = 0;
            #10;
            RN = 1; SN = 1; T = 1;
            #10;

            RN = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_Q;
        input expected_QN;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QN === (expected_QN ^ QN ^ expected_QN)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, QN=%b",
                         Q, QN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, QN=%b",
                         expected_Q, expected_QN);
                $display("  Got:      Q=%b, QN=%b",
                         Q, QN);
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

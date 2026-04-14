`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D1;
    reg D2;
    reg G1;
    reg G2;
    wire Q_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D1(D1),
        .D2(D2),
        .G1(G1),
        .G2(G2),
        .Q_(Q_)
    );
    task reset_latch;

        begin
            G1 = 1; G2 = 0; D1 = 0; D2 = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            reset_latch();
            G1 = 1; G2 = 0; D1 = 1;
            #5;
            $display("Testcase %0d: Select D1 (1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_latch();
            G1 = 1; G2 = 0; D1 = 0;
            #5;
            $display("Testcase %0d: Select D1 (0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_latch();
            G1 = 0; G2 = 1; D2 = 1;
            #5;
            $display("Testcase %0d: Select D2 (1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_latch();
            G1 = 0; G2 = 1; D2 = 0;
            #5;
            $display("Testcase %0d: Select D2 (0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_latch();

            G1 = 1; G2 = 0; D1 = 1;
            #5;

            G1 = 0; G2 = 0;
            #5;

            D1 = 0; D2 = 1;
            #5;
            $display("Testcase %0d: Latch Hold (Value 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_latch();

            G1 = 0; G2 = 1; D2 = 1;
            #5;

            G1 = 0; G2 = 0;
            #5;

            D1 = 1; D2 = 0;
            #5;
            $display("Testcase %0d: Latch Hold (Value 1 from D2)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_latch();
            G1 = 1; G2 = 0; D1 = 0;
            #5;
            D1 = 1;
            #5;
            $display("Testcase %0d: Level Sensitivity D1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_latch();
            G1 = 1; G2 = 0; D1 = 1;
            #5;
            D2 = 0;
            #5;
            $display("Testcase %0d: Isolation (D2 ignore)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_latch();

            G1 = 1; G2 = 0; D1 = 1;
            #5;

            G1 = 0; G2 = 0;
            #5;

            G1 = 0; G2 = 1; D2 = 0;
            #5;
            $display("Testcase %0d: Transition D1 -> Hold -> D2", test_num);
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
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_Q_;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q_ === (expected_Q_ ^ Q_ ^ expected_Q_)) begin
                $display("PASS");
                $display("  Outputs: Q_=%b",
                         Q_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q_=%b",
                         expected_Q_);
                $display("  Got:      Q_=%b",
                         Q_);
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

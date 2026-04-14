`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Addr_2;
    reg CI;
    reg S;
    reg lopt;
    reg lopt_1;
    wire LO;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr_2(Addr_2),
        .CI(CI),
        .S(S),
        .lopt(lopt),
        .lopt_1(lopt_1),
        .LO(LO),
        .O(O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            lopt = 0;
            lopt_1 = 0;
            S = 0;
            Addr_2 = 0;
            CI = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: lopt high, lopt_1 low", test_num);
            lopt = 1;
            lopt_1 = 0;
            S = 0;
            Addr_2 = 0;
            CI = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: lopt low, lopt_1 high", test_num);
            lopt = 0;
            lopt_1 = 1;
            S = 0;
            Addr_2 = 0;
            CI = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both lopt and lopt_1 high", test_num);
            lopt = 1;
            lopt_1 = 1;
            S = 0;
            Addr_2 = 0;
            CI = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unused inputs high (S, Addr_2, CI)", test_num);
            lopt = 1;
            lopt_1 = 0;
            S = 1;
            Addr_2 = 1;
            CI = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle lopt_1 while unused inputs are high", test_num);
            lopt = 0;
            lopt_1 = 1;
            S = 1;
            Addr_2 = 1;
            CI = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random unused input pattern", test_num);
            lopt = 1;
            lopt_1 = 1;
            S = 0;
            Addr_2 = 1;
            CI = 0;
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
        testcase007();
        
        
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
        input expected_LO;
        input expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LO === (expected_LO ^ LO ^ expected_LO) &&
                expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: LO=%b, O=%b",
                         LO, O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LO=%b, O=%b",
                         expected_LO, expected_O);
                $display("  Got:      LO=%b, O=%b",
                         LO, O);
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

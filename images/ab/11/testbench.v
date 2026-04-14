`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg B1;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .X(X)
    );
    task testcase001;

    begin
        test_num = 1;
        A1 = 1'b1; A2 = 1'b1; A3 = 1'b1; B1 = 1'b0;
        $display("Testcase %0d: All A high, B1 low (Condition: A1 AND A2 AND A3)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A1 = 1'b1; A2 = 1'b1; A3 = 1'b1; B1 = 1'b1;
        $display("Testcase %0d: All A high, B1 high (Condition: A1 AND A2 AND A3 takes priority)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A1 = 1'b0; A2 = 1'b0; A3 = 1'b0; B1 = 1'b1;
        $display("Testcase %0d: B1 high, none of A high (Condition: B1 AND NOT A1 AND NOT A2 AND NOT A3)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A1 = 1'b1; A2 = 1'b0; A3 = 1'b0; B1 = 1'b1;
        $display("Testcase %0d: B1 high, A1 high (Condition: otherwise low when at least one A high and B1 high)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A1 = 1'b0; A2 = 1'b1; A3 = 1'b1; B1 = 1'b1;
        $display("Testcase %0d: B1 high, A2 and A3 high (Condition: otherwise low when at least one A high and B1 high)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A1 = 1'b0; A2 = 1'b0; A3 = 1'b0; B1 = 1'b0;
        $display("Testcase %0d: All inputs low", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A1 = 1'b1; A2 = 1'b0; A3 = 1'b0; B1 = 1'b0;
        $display("Testcase %0d: Only A1 high, B1 low", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A1 = 1'b1; A2 = 1'b1; A3 = 1'b0; B1 = 1'b0;
        $display("Testcase %0d: A1 and A2 high, B1 low", test_num);
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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

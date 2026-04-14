`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire e;
    wire f;
    wire g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs low", test_num);
        a = 0; b = 0; c = 0; d = 0;
        #1;

        check_outputs(1, 1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs high", test_num);
        a = 1; b = 1; c = 1; d = 1;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Trigger e=0 (a=1, b=1)", test_num);
        a = 1; b = 1; c = 0; d = 0;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Trigger f=0 (e=1, c=1)", test_num);
        a = 0; b = 0; c = 1; d = 0;
        #1;

        check_outputs(1, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Trigger g=0 (f=1, d=1)", test_num);
        a = 0; b = 0; c = 0; d = 1;
        #1;

        check_outputs(1, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed inputs a=1, b=0, c=1, d=1", test_num);
        a = 1; b = 0; c = 1; d = 1;
        #1;

        check_outputs(1, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Toggle d with f=1 (a=1, b=1, c=1, d=0)", test_num);
        a = 1; b = 1; c = 1; d = 0;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed inputs a=0, b=1, c=1, d=1", test_num);
        a = 0; b = 1; c = 1; d = 1;
        #1;

        check_outputs(1, 0, 1);
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
        input expected_e;
        input expected_f;
        input expected_g;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_e === (expected_e ^ e ^ expected_e) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g)) begin
                $display("PASS");
                $display("  Outputs: e=%b, f=%b, g=%b",
                         e, f, g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=%b, f=%b, g=%b",
                         expected_e, expected_f, expected_g);
                $display("  Got:      e=%b, f=%b, g=%b",
                         e, f, g);
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

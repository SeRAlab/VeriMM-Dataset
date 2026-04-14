`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    wire and1;
    wire and2;
    wire and3;
    wire false_val;
    wire not1;
    wire not2;
    wire or1;
    wire or2;
    wire or3;
    wire true_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .and1(and1),
        .and2(and2),
        .and3(and3),
        .false_val(false_val),
        .not1(not1),
        .not2(not2),
        .or1(or1),
        .or2(or2),
        .or3(or3),
        .true_val(true_val)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 0; b = 0; c = 0;
        $display("Testcase %0d: a=%b, b=%b, c=%b", test_num, a, b, c);
        #1;

        check_outputs(0, 0, 0, 0, 1, 1, 0, 0, 0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 0; b = 0; c = 1;
        $display("Testcase %0d: a=%b, b=%b, c=%b", test_num, a, b, c);
        #1;

        check_outputs(0, 0, 0, 0, 1, 1, 0, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 0; b = 1; c = 0;
        $display("Testcase %0d: a=%b, b=%b, c=%b", test_num, a, b, c);
        #1;

        check_outputs(0, 0, 0, 0, 1, 0, 1, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 0; b = 1; c = 1;
        $display("Testcase %0d: a=%b, b=%b, c=%b", test_num, a, b, c);
        #1;

        check_outputs(0, 1, 0, 0, 1, 0, 1, 1, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 1; b = 0; c = 0;
        $display("Testcase %0d: a=%b, b=%b, c=%b", test_num, a, b, c);
        #1;

        check_outputs(0, 0, 0, 0, 0, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 1; b = 0; c = 1;
        $display("Testcase %0d: a=%b, b=%b, c=%b", test_num, a, b, c);
        #1;

        check_outputs(0, 0, 1, 0, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 1; b = 1; c = 0;
        $display("Testcase %0d: a=%b, b=%b, c=%b", test_num, a, b, c);
        #1;

        check_outputs(1, 0, 0, 0, 0, 0, 1, 1, 1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 1; b = 1; c = 1;
        $display("Testcase %0d: a=%b, b=%b, c=%b", test_num, a, b, c);
        #1;

        check_outputs(1, 1, 1, 0, 0, 0, 1, 1, 1, 1);
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
        input expected_and1;
        input expected_and2;
        input expected_and3;
        input expected_false_val;
        input expected_not1;
        input expected_not2;
        input expected_or1;
        input expected_or2;
        input expected_or3;
        input expected_true_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and1 === (expected_and1 ^ and1 ^ expected_and1) &&
                expected_and2 === (expected_and2 ^ and2 ^ expected_and2) &&
                expected_and3 === (expected_and3 ^ and3 ^ expected_and3) &&
                expected_false_val === (expected_false_val ^ false_val ^ expected_false_val) &&
                expected_not1 === (expected_not1 ^ not1 ^ expected_not1) &&
                expected_not2 === (expected_not2 ^ not2 ^ expected_not2) &&
                expected_or1 === (expected_or1 ^ or1 ^ expected_or1) &&
                expected_or2 === (expected_or2 ^ or2 ^ expected_or2) &&
                expected_or3 === (expected_or3 ^ or3 ^ expected_or3) &&
                expected_true_val === (expected_true_val ^ true_val ^ expected_true_val)) begin
                $display("PASS");
                $display("  Outputs: and1=%b, and2=%b, and3=%b, false_val=%b, not1=%b, not2=%b, or1=%b, or2=%b, or3=%b, true_val=%b",
                         and1, and2, and3, false_val, not1, not2, or1, or2, or3, true_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and1=%b, and2=%b, and3=%b, false_val=%b, not1=%b, not2=%b, or1=%b, or2=%b, or3=%b, true_val=%b",
                         expected_and1, expected_and2, expected_and3, expected_false_val, expected_not1, expected_not2, expected_or1, expected_or2, expected_or3, expected_true_val);
                $display("  Got:      and1=%b, and2=%b, and3=%b, false_val=%b, not1=%b, not2=%b, or1=%b, or2=%b, or3=%b, true_val=%b",
                         and1, and2, and3, false_val, not1, not2, or1, or2, or3, true_val);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg y;
    wire a;
    wire b;
    wire c;
    wire d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .a(a),
        .b(b),
        .c(c),
        .d(d)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: x=0, y=0", test_num);
        x = 1'b0;
        y = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: x=0, y=1", test_num);
        x = 1'b0;
        y = 1'b1;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: x=1, y=0", test_num);
        x = 1'b1;
        y = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: x=1, y=1", test_num);
        x = 1'b1;
        y = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
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
        input expected_a;
        input expected_b;
        input expected_c;
        input expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: a=%b, b=%b, c=%b, d=%b",
                         a, b, c, d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%b, b=%b, c=%b, d=%b",
                         expected_a, expected_b, expected_c, expected_d);
                $display("  Got:      a=%b, b=%b, c=%b, d=%b",
                         a, b, c, d);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire yAND;
    wire yNAND;
    wire yNOR;
    wire yOR;
    wire yXNOR;
    wire yXOR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .yAND(yAND),
        .yNAND(yNAND),
        .yNOR(yNOR),
        .yOR(yOR),
        .yXNOR(yXNOR),
        .yXOR(yXOR)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: a=0, b=0", test_num);
        a = 0; b = 0;

        #1;


        check_outputs(0, 1, 1, 0, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: a=0, b=1", test_num);
        a = 0; b = 1;

        #1;


        check_outputs(0, 1, 0, 1, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: a=1, b=0", test_num);
        a = 1; b = 0;

        #1;


        check_outputs(0, 1, 0, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: a=1, b=1", test_num);
        a = 1; b = 1;

        #1;


        check_outputs(1, 0, 0, 1, 1, 0);
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
        input expected_yAND;
        input expected_yNAND;
        input expected_yNOR;
        input expected_yOR;
        input expected_yXNOR;
        input expected_yXOR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_yAND === (expected_yAND ^ yAND ^ expected_yAND) &&
                expected_yNAND === (expected_yNAND ^ yNAND ^ expected_yNAND) &&
                expected_yNOR === (expected_yNOR ^ yNOR ^ expected_yNOR) &&
                expected_yOR === (expected_yOR ^ yOR ^ expected_yOR) &&
                expected_yXNOR === (expected_yXNOR ^ yXNOR ^ expected_yXNOR) &&
                expected_yXOR === (expected_yXOR ^ yXOR ^ expected_yXOR)) begin
                $display("PASS");
                $display("  Outputs: yAND=%b, yNAND=%b, yNOR=%b, yOR=%b, yXNOR=%b, yXOR=%b",
                         yAND, yNAND, yNOR, yOR, yXNOR, yXOR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: yAND=%b, yNAND=%b, yNOR=%b, yOR=%b, yXNOR=%b, yXOR=%b",
                         expected_yAND, expected_yNAND, expected_yNOR, expected_yOR, expected_yXNOR, expected_yXOR);
                $display("  Got:      yAND=%b, yNAND=%b, yNOR=%b, yOR=%b, yXNOR=%b, yXOR=%b",
                         yAND, yNAND, yNOR, yOR, yXNOR, yXOR);
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

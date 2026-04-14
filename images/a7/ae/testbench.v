`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i;
    reg j;
    reg k;
    wire l_pos;
    wire l_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .j(j),
        .k(k),
        .l_pos(l_pos),
        .l_sop(l_sop)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 0 (i=0, j=0, k=0) - Expected: 1", test_num);
        i = 0; j = 0; k = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 1 (i=0, j=0, k=1) - Expected: 0", test_num);
        i = 0; j = 0; k = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 2 (i=0, j=1, k=0) - Expected: 1", test_num);
        i = 0; j = 1; k = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 3 (i=0, j=1, k=1) - Expected: 0", test_num);
        i = 0; j = 1; k = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 4 (i=1, j=0, k=0) - Expected: 0", test_num);
        i = 1; j = 0; k = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 5 (i=1, j=0, k=1) - Expected: 1", test_num);
        i = 1; j = 0; k = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Binary 6 (i=1, j=1, k=0) - Expected: 0", test_num);
        i = 1; j = 1; k = 0;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_l_pos;
        input expected_l_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l_pos === (expected_l_pos ^ l_pos ^ expected_l_pos) &&
                expected_l_sop === (expected_l_sop ^ l_sop ^ expected_l_sop)) begin
                $display("PASS");
                $display("  Outputs: l_pos=%b, l_sop=%b",
                         l_pos, l_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l_pos=%b, l_sop=%b",
                         expected_l_pos, expected_l_sop);
                $display("  Got:      l_pos=%b, l_sop=%b",
                         l_pos, l_sop);
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg p;
    reg q;
    reg r;
    wire t_pos;
    wire t_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p(p),
        .q(q),
        .r(r),
        .t_pos(t_pos),
        .t_sop(t_sop)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 000", test_num);
        p = 0; q = 0; r = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 001", test_num);
        p = 0; q = 0; r = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 010", test_num);
        p = 0; q = 1; r = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 011", test_num);
        p = 0; q = 1; r = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 100", test_num);
        p = 1; q = 0; r = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 101", test_num);
        p = 1; q = 0; r = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 110", test_num);
        p = 1; q = 1; r = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 111", test_num);
        p = 1; q = 1; r = 1;
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
        input expected_t_pos;
        input expected_t_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_t_pos === (expected_t_pos ^ t_pos ^ expected_t_pos) &&
                expected_t_sop === (expected_t_sop ^ t_sop ^ expected_t_sop)) begin
                $display("PASS");
                $display("  Outputs: t_pos=%b, t_sop=%b",
                         t_pos, t_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: t_pos=%b, t_sop=%b",
                         expected_t_pos, expected_t_sop);
                $display("  Got:      t_pos=%b, t_sop=%b",
                         t_pos, t_sop);
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

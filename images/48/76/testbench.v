`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire q_pos;
    wire q_sop;

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
        .q_pos(q_pos),
        .q_sop(q_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input Binary 1 (0001)", test_num);
        a = 0; b = 0; c = 0; d = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input Binary 2 (0010)", test_num);
        a = 0; b = 0; c = 1; d = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input Binary 4 (0100)", test_num);
        a = 0; b = 1; c = 0; d = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input Binary 8 (1000)", test_num);
        a = 1; b = 0; c = 0; d = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input Binary 0 (0000)", test_num);
        a = 0; b = 0; c = 0; d = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input Binary 3 (0011)", test_num);
        a = 0; b = 0; c = 1; d = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input Binary 5 (0101)", test_num);
        a = 0; b = 1; c = 0; d = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input Binary 10 (1010)", test_num);
        a = 1; b = 0; c = 1; d = 0;
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
        input expected_q_pos;
        input expected_q_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q_pos === (expected_q_pos ^ q_pos ^ expected_q_pos) &&
                expected_q_sop === (expected_q_sop ^ q_sop ^ expected_q_sop)) begin
                $display("PASS");
                $display("  Outputs: q_pos=%b, q_sop=%b",
                         q_pos, q_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_pos=%b, q_sop=%b",
                         expected_q_pos, expected_q_sop);
                $display("  Got:      q_pos=%b, q_sop=%b",
                         q_pos, q_sop);
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

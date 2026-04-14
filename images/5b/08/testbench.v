`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg m;
    reg n;
    reg o;
    wire k_pos;
    wire k_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m(m),
        .n(n),
        .o(o),
        .k_pos(k_pos),
        .k_sop(k_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        m = 1'b0; n = 1'b0; o = 1'b0;
        $display("Testcase %0d: Input (m,n,o) = 000 (Val 0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        m = 1'b0; n = 1'b0; o = 1'b1;
        $display("Testcase %0d: Input (m,n,o) = 001 (Val 1)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        m = 1'b0; n = 1'b1; o = 1'b0;
        $display("Testcase %0d: Input (m,n,o) = 010 (Val 2)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        m = 1'b0; n = 1'b1; o = 1'b1;
        $display("Testcase %0d: Input (m,n,o) = 011 (Val 3)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        m = 1'b1; n = 1'b0; o = 1'b0;
        $display("Testcase %0d: Input (m,n,o) = 100 (Val 4)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        m = 1'b1; n = 1'b0; o = 1'b1;
        $display("Testcase %0d: Input (m,n,o) = 101 (Val 5)", test_num);
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
        input expected_k_pos;
        input expected_k_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_k_pos === (expected_k_pos ^ k_pos ^ expected_k_pos) &&
                expected_k_sop === (expected_k_sop ^ k_sop ^ expected_k_sop)) begin
                $display("PASS");
                $display("  Outputs: k_pos=%b, k_sop=%b",
                         k_pos, k_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: k_pos=%b, k_sop=%b",
                         expected_k_pos, expected_k_sop);
                $display("  Got:      k_pos=%b, k_sop=%b",
                         k_pos, k_sop);
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

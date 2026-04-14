`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg e;
    reg f;
    reg g;
    reg h;
    wire k_pos;
    wire k_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .k_pos(k_pos),
        .k_sop(k_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        e = 0; f = 0; g = 0; h = 0;
        $display("Test %0d: Input efgh=0000 (Decimal 0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        e = 0; f = 0; g = 0; h = 1;
        $display("Test %0d: Input efgh=0001 (Decimal 1)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        e = 0; f = 0; g = 1; h = 0;
        $display("Test %0d: Input efgh=0010 (Decimal 2)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        e = 0; f = 0; g = 1; h = 1;
        $display("Test %0d: Input efgh=0011 (Decimal 3)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        e = 0; f = 1; g = 0; h = 0;
        $display("Test %0d: Input efgh=0100 (Decimal 4)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        e = 0; f = 1; g = 0; h = 1;
        $display("Test %0d: Input efgh=0101 (Decimal 5)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        e = 0; f = 1; g = 1; h = 0;
        $display("Test %0d: Input efgh=0110 (Decimal 6)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        e = 0; f = 1; g = 1; h = 1;
        $display("Test %0d: Input efgh=0111 (Decimal 7)", test_num);
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

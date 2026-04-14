`timescale 1ns/1ps

module my_module_tb;

    // Testbench signals (combinational circuit)
    reg p;
    reg q;
    reg r;
    wire m_pos;
    wire m_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    my_module dut (
        .p(p),
        .q(q),
        .r(r),
        .m_pos(m_pos),
        .m_sop(m_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Input 000 (0)", test_num);
        p = 0; q = 0; r = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Input 001 (1)", test_num);
        p = 0; q = 0; r = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Input 010 (2) - Expected PASS", test_num);
        p = 0; q = 1; r = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Input 011 (3)", test_num);
        p = 0; q = 1; r = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Input 100 (4) - Expected PASS", test_num);
        p = 1; q = 0; r = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Input 101 (5)", test_num);
        p = 1; q = 0; r = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Input 110 (6)", test_num);
        p = 1; q = 1; r = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Input 111 (7) - Expected PASS", test_num);
        p = 1; q = 1; r = 1;
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
        $display("my_module Testbench");
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
        input expected_m_pos;
        input expected_m_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m_pos === (expected_m_pos ^ m_pos ^ expected_m_pos) &&
                expected_m_sop === (expected_m_sop ^ m_sop ^ expected_m_sop)) begin
                $display("PASS");
                $display("  Outputs: m_pos=%b, m_sop=%b",
                         m_pos, m_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_pos=%b, m_sop=%b",
                         expected_m_pos, expected_m_sop);
                $display("  Got:      m_pos=%b, m_sop=%b",
                         m_pos, m_sop);
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

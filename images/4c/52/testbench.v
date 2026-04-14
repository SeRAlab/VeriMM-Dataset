`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg m;
    reg n;
    reg o;
    reg p;
    wire m_pos;
    wire m_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m(m),
        .n(n),
        .o(o),
        .p(p),
        .m_pos(m_pos),
        .m_sop(m_sop)
    );
    task testcase001;

        begin
            test_num = 1;
            {m, n, o, p} = 4'b0000;
            $display("Testcase %0d: Binary value 0 (0000)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            {m, n, o, p} = 4'b0001;
            $display("Testcase %0d: Binary value 1 (0001)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            {m, n, o, p} = 4'b0010;
            $display("Testcase %0d: Binary value 2 (0010)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            {m, n, o, p} = 4'b0011;
            $display("Testcase %0d: Binary value 3 (0011)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            {m, n, o, p} = 4'b0100;
            $display("Testcase %0d: Binary value 4 (0100)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            {m, n, o, p} = 4'b0101;
            $display("Testcase %0d: Binary value 5 (0101)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            {m, n, o, p} = 4'b0110;
            $display("Testcase %0d: Binary value 6 (0110)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            {m, n, o, p} = 4'b0111;
            $display("Testcase %0d: Binary value 7 (0111)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            {m, n, o, p} = 4'b1000;
            $display("Testcase %0d: Binary value 8 (1000)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            {m, n, o, p} = 4'b1001;
            $display("Testcase %0d: Binary value 9 (1001)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            {m, n, o, p} = 4'b1010;
            $display("Testcase %0d: Binary value 10 (1010)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            {m, n, o, p} = 4'b1011;
            $display("Testcase %0d: Binary value 11 (1011)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            {m, n, o, p} = 4'b1100;
            $display("Testcase %0d: Binary value 12 (1100)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            {m, n, o, p} = 4'b1101;
            $display("Testcase %0d: Binary value 13 (1101)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            {m, n, o, p} = 4'b1110;
            $display("Testcase %0d: Binary value 14 (1110)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            {m, n, o, p} = 4'b1111;
            $display("Testcase %0d: Binary value 15 (1111)", test_num);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg p;
    reg q;
    reg r;
    reg s;
    wire out_pos;
    wire out_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p(p),
        .q(q),
        .r(r),
        .s(s),
        .out_pos(out_pos),
        .out_sop(out_sop)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Binary 0 (0000)", test_num);
            p = 0; q = 0; r = 0; s = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Binary 1 (0001)", test_num);
            p = 0; q = 0; r = 0; s = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Binary 2 (0010)", test_num);
            p = 0; q = 0; r = 1; s = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Binary 3 (0011)", test_num);
            p = 0; q = 0; r = 1; s = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Binary 4 (0100)", test_num);
            p = 0; q = 1; r = 0; s = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Binary 5 (0101)", test_num);
            p = 0; q = 1; r = 0; s = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Binary 6 (0110)", test_num);
            p = 0; q = 1; r = 1; s = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Binary 7 (0111)", test_num);
            p = 0; q = 1; r = 1; s = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Binary 8 (1000)", test_num);
            p = 1; q = 0; r = 0; s = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Binary 9 (1001)", test_num);
            p = 1; q = 0; r = 0; s = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Binary 10 (1010)", test_num);
            p = 1; q = 0; r = 1; s = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: Binary 11 (1011)", test_num);
            p = 1; q = 0; r = 1; s = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test %0d: Binary 12 (1100)", test_num);
            p = 1; q = 1; r = 0; s = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Test %0d: Binary 13 (1101)", test_num);
            p = 1; q = 1; r = 0; s = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Test %0d: Binary 14 (1110)", test_num);
            p = 1; q = 1; r = 1; s = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            $display("Test %0d: Binary 15 (1111)", test_num);
            p = 1; q = 1; r = 1; s = 1;
            #1;

            check_outputs(1, 1);
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
        input expected_out_pos;
        input expected_out_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_pos === (expected_out_pos ^ out_pos ^ expected_out_pos) &&
                expected_out_sop === (expected_out_sop ^ out_sop ^ expected_out_sop)) begin
                $display("PASS");
                $display("  Outputs: out_pos=%b, out_sop=%b",
                         out_pos, out_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_pos=%b, out_sop=%b",
                         expected_out_pos, expected_out_sop);
                $display("  Got:      out_pos=%b, out_sop=%b",
                         out_pos, out_sop);
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

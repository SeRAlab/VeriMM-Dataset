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
    task testcase000;

        begin
            test_num = 0;
            p = 0; q = 0; r = 0; s = 0;
            $display("Testcase %0d: Binary 0000 (0)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            p = 0; q = 0; r = 0; s = 1;
            $display("Testcase %0d: Binary 0001 (1)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            p = 0; q = 0; r = 1; s = 0;
            $display("Testcase %0d: Binary 0010 (2)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            p = 0; q = 0; r = 1; s = 1;
            $display("Testcase %0d: Binary 0011 (3)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            p = 0; q = 1; r = 0; s = 0;
            $display("Testcase %0d: Binary 0100 (4)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            p = 0; q = 1; r = 1; s = 1;
            $display("Testcase %0d: Binary 0111 (7)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            p = 1; q = 0; r = 0; s = 0;
            $display("Testcase %0d: Binary 1000 (8)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            p = 1; q = 0; r = 0; s = 1;
            $display("Testcase %0d: Binary 1001 (9)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            p = 1; q = 0; r = 1; s = 0;
            $display("Testcase %0d: Binary 1010 (10)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            p = 1; q = 1; r = 0; s = 0;
            $display("Testcase %0d: Binary 1100 (12)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            p = 1; q = 1; r = 1; s = 1;
            $display("Testcase %0d: Binary 1111 (15)", test_num);
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


        testcase000();
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

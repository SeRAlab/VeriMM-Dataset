`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a0;
    reg a1;
    reg a2;
    reg a3;
    reg s0;
    reg s1;
    wire op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .s0(s0),
        .s1(s1),
        .op(op)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select line {s1,s0}=00, setting a0=0 (other inputs 1)", test_num);
            s1 = 0; s0 = 0;
            a0 = 0; a1 = 1; a2 = 1; a3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select line {s1,s0}=00, setting a0=1 (other inputs 0)", test_num);
            s1 = 0; s0 = 0;
            a0 = 1; a1 = 0; a2 = 0; a3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select line {s1,s0}=01, setting a1=0 (other inputs 1)", test_num);
            s1 = 0; s0 = 1;
            a0 = 1; a1 = 0; a2 = 1; a3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select line {s1,s0}=01, setting a1=1 (other inputs 0)", test_num);
            s1 = 0; s0 = 1;
            a0 = 0; a1 = 1; a2 = 0; a3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select line {s1,s0}=10, setting a2=0 (other inputs 1)", test_num);
            s1 = 1; s0 = 0;
            a0 = 1; a1 = 1; a2 = 0; a3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select line {s1,s0}=10, setting a2=1 (other inputs 0)", test_num);
            s1 = 1; s0 = 0;
            a0 = 0; a1 = 0; a2 = 1; a3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select line {s1,s0}=11, setting a3=0 (other inputs 1)", test_num);
            s1 = 1; s0 = 1;
            a0 = 1; a1 = 1; a2 = 1; a3 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select line {s1,s0}=11, setting a3=1 (other inputs 0)", test_num);
            s1 = 1; s0 = 1;
            a0 = 0; a1 = 0; a2 = 0; a3 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select a0=1, then toggle a1 to ensure no interference", test_num);
            s1 = 0; s0 = 0; a0 = 1; a1 = 0; a2 = 0; a3 = 0;
            #5;
            a1 = 1;
            #1;

            check_outputs(1'b1);
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
        input expected_op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%b",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%b",
                         expected_op);
                $display("  Got:      op=%b",
                         op);
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

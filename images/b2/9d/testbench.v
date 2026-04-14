`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a__4;
    reg a__5;
    reg a__6;
    reg b__4;
    wire n__248;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a__4(a__4),
        .a__5(a__5),
        .a__6(a__6),
        .b__4(b__4),
        .n__248(n__248)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs low", test_num);
            a__4 = 0; a__5 = 0; a__6 = 0; b__4 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All inputs high", test_num);
            a__4 = 1; a__5 = 1; a__6 = 1; b__4 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: a__4 low, others high", test_num);
            a__4 = 0; a__5 = 1; a__6 = 1; b__4 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: a__5 low, others high", test_num);
            a__4 = 1; a__5 = 0; a__6 = 1; b__4 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: a__6 low, others high", test_num);
            a__4 = 1; a__5 = 1; a__6 = 0; b__4 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: b__4 low, others high", test_num);
            a__4 = 1; a__5 = 1; a__6 = 1; b__4 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: a__4 and a__5 low", test_num);
            a__4 = 0; a__5 = 0; a__6 = 1; b__4 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: a__6 and b__4 low", test_num);
            a__4 = 1; a__5 = 1; a__6 = 0; b__4 = 0;
            #1;

            check_outputs(0);
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
        input expected_n__248;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n__248 === (expected_n__248 ^ n__248 ^ expected_n__248)) begin
                $display("PASS");
                $display("  Outputs: n__248=%b",
                         n__248);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n__248=%b",
                         expected_n__248);
                $display("  Got:      n__248=%b",
                         n__248);
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

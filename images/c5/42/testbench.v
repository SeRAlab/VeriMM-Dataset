`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire out_comb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_comb(out_comb)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 0;
            b = 0;
            $display("\nTest Case %0d: a=0, b=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 0;
            b = 1;
            $display("\nTest Case %0d: a=0, b=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 1;
            b = 0;
            $display("\nTest Case %0d: a=1, b=0", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 1;
            b = 1;
            $display("\nTest Case %0d: a=1, b=1", test_num);
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
        input expected_out_comb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_comb === (expected_out_comb ^ out_comb ^ expected_out_comb)) begin
                $display("PASS");
                $display("  Outputs: out_comb=%b",
                         out_comb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_comb=%b",
                         expected_out_comb);
                $display("  Got:      out_comb=%b",
                         out_comb);
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

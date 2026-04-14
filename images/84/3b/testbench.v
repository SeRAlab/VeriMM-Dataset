`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire out_lut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_lut(out_lut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing a=0, b=0 (Expect 0)", test_num);
            a = 0;
            b = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing a=0, b=1 (Expect 1)", test_num);
            a = 0;
            b = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing a=1, b=0 (Expect 1)", test_num);
            a = 1;
            b = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing a=1, b=1 (Expect 0)", test_num);
            a = 1;
            b = 1;
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
        input expected_out_lut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_lut === (expected_out_lut ^ out_lut ^ expected_out_lut)) begin
                $display("PASS");
                $display("  Outputs: out_lut=%b",
                         out_lut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_lut=%b",
                         expected_out_lut);
                $display("  Got:      out_lut=%b",
                         out_lut);
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

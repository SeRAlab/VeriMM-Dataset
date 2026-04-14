`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .z(z)
    );
    task testcase001;

        begin
            $display("Test Case 001: a=0, b=0, c=1");
            test_num = 1;
            a = 1'b0;
            b = 1'b0;
            c = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: a=1, b=0, c=1");
            test_num = 2;
            a = 1'b1;
            b = 1'b0;
            c = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: a=1, b=1, c=0");
            test_num = 3;
            a = 1'b1;
            b = 1'b1;
            c = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: a=0, b=1, c=0");
            test_num = 4;
            a = 1'b0;
            b = 1'b1;
            c = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: a=0, b=0, c=0");
            test_num = 5;
            a = 1'b0;
            b = 1'b0;
            c = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: a=1, b=1, c=1");
            test_num = 6;
            a = 1'b1;
            b = 1'b1;
            c = 1'b1;
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
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%b",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%b",
                         expected_z);
                $display("  Got:      z=%b",
                         z);
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

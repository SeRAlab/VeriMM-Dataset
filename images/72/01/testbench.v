`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in1;
    reg in2;
    reg in3;
    reg in4;
    wire out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .out1(out1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All inputs LOW");
            in1 = 0; in2 = 0; in3 = 0; in4 = 0;
            #50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All inputs HIGH");
            in1 = 1; in2 = 1; in3 = 1; in4 = 1;
            #50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: in1 LOW, others HIGH");
            in1 = 0; in2 = 1; in3 = 1; in4 = 1;
            #50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: in2 LOW, others HIGH");
            in1 = 1; in2 = 0; in3 = 1; in4 = 1;
            #50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: in3 LOW, others HIGH");
            in1 = 1; in2 = 1; in3 = 0; in4 = 1;
            #50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: in4 LOW, others HIGH");
            in1 = 1; in2 = 1; in3 = 1; in4 = 0;
            #50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Two inputs LOW");
            in1 = 0; in2 = 0; in3 = 1; in4 = 1;
            #50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Transition from All-HIGH to Mixed");
            in1 = 1; in2 = 1; in3 = 1; in4 = 1;
            #50;
            in3 = 0;
            #50;
            #1;

            check_outputs(1'b0);
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
        input expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%b",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%b",
                         expected_out1);
                $display("  Got:      out1=%b",
                         out1);
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

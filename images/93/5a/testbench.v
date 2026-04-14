`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] mult_output;
    wire mult_overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mult_output(mult_output),
        .mult_overflow(mult_overflow)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        mult_output = 32'h00000000;
        $display("Test Case %0d: mult_output = %h (Zero)", test_num, mult_output);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        mult_output = 32'hFFFFFFFF;
        $display("Test Case %0d: mult_output = %h (All Ones)", test_num, mult_output);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        mult_output = 32'h00000001;
        $display("Test Case %0d: mult_output = %h (Small Positive)", test_num, mult_output);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        mult_output = 32'hFFFFFFFE;
        $display("Test Case %0d: mult_output = %h (Small Negative)", test_num, mult_output);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        mult_output = 32'h7FFFFFFF;
        $display("Test Case %0d: mult_output = %h (Max Positive)", test_num, mult_output);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        mult_output = 32'h80000000;
        $display("Test Case %0d: mult_output = %h (Max Negative)", test_num, mult_output);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        mult_output = 32'hAAAA5555;
        $display("Test Case %0d: mult_output = %h (Pattern)", test_num, mult_output);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        mult_output = 32'h00000002;
        $display("Test Case %0d: mult_output = %h (Boundary)", test_num, mult_output);
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
        input expected_mult_overflow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mult_overflow === (expected_mult_overflow ^ mult_overflow ^ expected_mult_overflow)) begin
                $display("PASS");
                $display("  Outputs: mult_overflow=%b",
                         mult_overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mult_overflow=%b",
                         expected_mult_overflow);
                $display("  Got:      mult_overflow=%b",
                         mult_overflow);
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

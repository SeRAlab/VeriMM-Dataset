`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clr;
    reg in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clr(clr),
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;

        clr = 0;
        in = 0;
        #5;
        $display("Testcase %0d: Active-low clear with input low", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        clr = 0;
        in = 1;
        #5;
        $display("Testcase %0d: Active-low clear with input high (Reset override)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        clr = 0;
        in = 0;
        #5;

        clr = 1;
        in = 1;
        #5;
        $display("Testcase %0d: Clear inactive, input high", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        clr = 0;
        in = 0;
        #5;

        clr = 1;
        in = 0;
        #5;
        $display("Testcase %0d: Clear inactive, input low", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        clr = 0;
        in = 0;
        #5;

        clr = 1;
        in = 1;
        #5;
        clr = 0;
        #5;
        $display("Testcase %0d: Transitions from high to active-low clear", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        clr = 0;
        in = 1;
        #5;

        in = 0;
        #2;
        in = 1;
        #5;
        $display("Testcase %0d: Input toggling while clear is active", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        clr = 0;
        in = 0;
        #5;

        clr = 1;
        in = 1;
        #2;
        in = 0;
        #2;
        in = 1;
        #5;
        $display("Testcase %0d: Input toggling while clear is inactive", test_num);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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

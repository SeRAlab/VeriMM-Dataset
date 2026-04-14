`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c0;
    reg c1;
    reg c2;
    reg c3;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .out(out)
    );
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Inputs 0-3");
            {c3, c2, c1, c0} = 4'b0000; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b0001; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b0010; #1;
 check_outputs(1'b1);
            {c3, c2, c1, c0} = 4'b0011; #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Inputs 4-7");
            {c3, c2, c1, c0} = 4'b0100; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b0101; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b0110; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b0111; #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Inputs 8-11");
            {c3, c2, c1, c0} = 4'b1000; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b1001; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b1010; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b1011; #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Inputs 12-15");
            {c3, c2, c1, c0} = 4'b1100; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b1101; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b1110; #1;
 check_outputs(1'b0);
            {c3, c2, c1, c0} = 4'b1111; #1;
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

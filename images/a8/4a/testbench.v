`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .f(f)
    );
    task testcase001;

    begin
        $display("Running Testcase Group 001: x = 0 to 3");
        x = 4'b0000; #1;
 check_outputs(1'b1);
        x = 4'b0001; #1;
 check_outputs(1'b1);
        x = 4'b0010; #1;
 check_outputs(1'b0);
        x = 4'b0011; #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase Group 002: x = 4 to 7");
        x = 4'b0100; #1;
 check_outputs(1'b1);
        x = 4'b0101; #1;
 check_outputs(1'b1);
        x = 4'b0110; #1;
 check_outputs(1'b1);
        x = 4'b0111; #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase Group 003: x = 8 to 11");
        x = 4'b1000; #1;
 check_outputs(1'b0);
        x = 4'b1001; #1;
 check_outputs(1'b1);
        x = 4'b1010; #1;
 check_outputs(1'b0);
        x = 4'b1011; #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase Group 004: x = 12 to 15");
        x = 4'b1100; #1;
 check_outputs(1'b1);
        x = 4'b1101; #1;
 check_outputs(1'b1);
        x = 4'b1110; #1;
 check_outputs(1'b1);
        x = 4'b1111; #1;
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
        input expected_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%b",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%b",
                         expected_f);
                $display("  Got:      f=%b",
                         f);
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

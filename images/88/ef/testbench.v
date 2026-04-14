`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg z;
    wire cond;
    wire [2:0] irc;
    wire n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .z(z),
        .cond(cond),
        .irc(irc),
        .n(n)
    );
    task testcase001;

        begin
            $display("Running testcase001: Input z = 0");
            test_num = test_num + 1;


            z = 1'b0;


            #10;




            #1;





            check_outputs(1'b0, 3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Input z = 1");
            test_num = test_num + 1;


            z = 1'b1;


            #10;




            #1;





            check_outputs(1'b1, 3'b000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Transition z from 1 to 0");
            test_num = test_num + 1;

            z = 1'b1;
            #5;
            z = 1'b0;

            #10;

            #1;


            check_outputs(1'b0, 3'b000, 1'b0);
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
        input expected_cond;
        input [2:0] expected_irc;
        input expected_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cond === (expected_cond ^ cond ^ expected_cond) &&
                expected_irc === (expected_irc ^ irc ^ expected_irc) &&
                expected_n === (expected_n ^ n ^ expected_n)) begin
                $display("PASS");
                $display("  Outputs: cond=%b, irc=%h, n=%b",
                         cond, irc, n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cond=%b, irc=%h, n=%b",
                         expected_cond, expected_irc, expected_n);
                $display("  Got:      cond=%b, irc=%h, n=%b",
                         cond, irc, n);
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

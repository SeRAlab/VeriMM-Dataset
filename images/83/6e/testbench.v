`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg RST;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initial Reset State");
            CLK = 0;
            RST = 1;
            #20;
            RST = 0;
            #10;
            expected_z1 = 1'b0;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single Clock Cycle Toggle");
            CLK = 0;
            RST = 1; #20;
            RST = 0; #10;

            CLK = 1; #10;
            CLK = 0; #10;
            expected_z1 = 1'b1;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Double Clock Cycle Toggle");
            CLK = 0;
            RST = 1; #20;
            RST = 0; #10;

            repeat(2) begin
                CLK = 1; #10;
                CLK = 0; #10;
            end
            expected_z1 = 1'b0;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Multiple Cycles (7) Oscillation");
            CLK = 0;
            RST = 1; #20;
            RST = 0; #10;
            repeat(7) begin
                CLK = 1; #10;
                CLK = 0; #10;
            end
            expected_z1 = 1'b1;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Reset during Active State");
            CLK = 0;
            RST = 1; #20;
            RST = 0; #10;
            CLK = 1; #10;
            CLK = 0; #10;
            RST = 1;
            #10;
            expected_z1 = 1'b0;
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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

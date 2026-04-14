`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire clock160;
    wire clock40;
    wire clock80;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock160(clock160),
        .clock40(clock40),
        .clock80(clock80)
    );
    task testcase001;

        begin
            test_num = 1;


            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            #3;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            #12;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_clock160;
        input expected_clock40;
        input expected_clock80;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clock160 === (expected_clock160 ^ clock160 ^ expected_clock160) &&
                expected_clock40 === (expected_clock40 ^ clock40 ^ expected_clock40) &&
                expected_clock80 === (expected_clock80 ^ clock80 ^ expected_clock80)) begin
                $display("PASS");
                $display("  Outputs: clock160=%b, clock40=%b, clock80=%b",
                         clock160, clock40, clock80);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clock160=%b, clock40=%b, clock80=%b",
                         expected_clock160, expected_clock40, expected_clock80);
                $display("  Got:      clock160=%b, clock40=%b, clock80=%b",
                         clock160, clock40, clock80);
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

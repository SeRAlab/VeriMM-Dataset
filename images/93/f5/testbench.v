`timescale 1ns/1ps

module control_module_tb;

    // Testbench signals (combinational circuit)
    reg w;
    reg x;
    wire [3:0] mux_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    control_module dut (
        .w(w),
        .x(x),
        .mux_result(mux_result)
    );
    task testcase001;

        begin
            $display("Testcase 001: w=0, x=0");
            test_num = 1;
            w = 0;
            x = 0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: w=0, x=1");
            test_num = 2;
            w = 0;
            x = 1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: w=1, x=0");
            test_num = 3;
            w = 1;
            x = 0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: w=1, x=1");
            test_num = 4;
            w = 1;
            x = 1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("control_module Testbench");
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
        input [3:0] expected_mux_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_result === (expected_mux_result ^ mux_result ^ expected_mux_result)) begin
                $display("PASS");
                $display("  Outputs: mux_result=%h",
                         mux_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_result=%h",
                         expected_mux_result);
                $display("  Got:      mux_result=%h",
                         mux_result);
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

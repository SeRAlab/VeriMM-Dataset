`timescale 1ns/1ps

module mux_module_tb;

    // Testbench signals (combinational circuit)
    reg w;
    reg z;
    wire [3:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_module dut (
        .w(w),
        .z(z),
        .mux_out(mux_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Inputs w=0, z=0");
        w = 1'b0;
        z = 1'b0;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Inputs w=0, z=1");
        w = 1'b0;
        z = 1'b1;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Inputs w=1, z=0");
        w = 1'b1;
        z = 1'b0;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Inputs w=1, z=1");
        w = 1'b1;
        z = 1'b1;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_module Testbench");
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
        input [3:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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

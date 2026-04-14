`timescale 1ns/1ps

module config_module_tb;

    // Testbench signals (combinational circuit)
    reg o;
    reg p;
    wire [3:0] mux_vals;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    config_module dut (
        .o(o),
        .p(p),
        .mux_vals(mux_vals)
    );
    task testcase001;

    begin
        test_num = 1;
        o = 1'b0;
        p = 1'b0;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        o = 1'b0;
        p = 1'b1;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        o = 1'b1;
        p = 1'b0;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        o = 1'b1;
        p = 1'b1;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("config_module Testbench");
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
        input [3:0] expected_mux_vals;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_vals === (expected_mux_vals ^ mux_vals ^ expected_mux_vals)) begin
                $display("PASS");
                $display("  Outputs: mux_vals=%h",
                         mux_vals);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_vals=%h",
                         expected_mux_vals);
                $display("  Got:      mux_vals=%h",
                         mux_vals);
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

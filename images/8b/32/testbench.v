`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg w;
    reg x;
    reg y;
    reg z;
    wire out_pos;
    wire out_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w(w),
        .x(x),
        .y(y),
        .z(z),
        .out_pos(out_pos),
        .out_sop(out_sop)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        
        
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
        input expected_out_pos;
        input expected_out_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_pos === (expected_out_pos ^ out_pos ^ expected_out_pos) &&
                expected_out_sop === (expected_out_sop ^ out_sop ^ expected_out_sop)) begin
                $display("PASS");
                $display("  Outputs: out_pos=%b, out_sop=%b",
                         out_pos, out_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_pos=%b, out_sop=%b",
                         expected_out_pos, expected_out_sop);
                $display("  Got:      out_pos=%b, out_sop=%b",
                         out_pos, out_sop);
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

`timescale 1ns/1ps

module alu_mux_2z_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg sel_a;
    reg sel_zero;
    wire [3:0] Q;
    wire ena;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_mux_2z dut (
        .a(a),
        .sel_a(sel_a),
        .sel_zero(sel_zero),
        .Q(Q),
        .ena(ena)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_mux_2z Testbench");
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
        input [3:0] expected_Q;
        input expected_ena;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_ena === (expected_ena ^ ena ^ expected_ena)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, ena=%b",
                         Q, ena);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, ena=%b",
                         expected_Q, expected_ena);
                $display("  Got:      Q=%h, ena=%b",
                         Q, ena);
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

`timescale 1ns/1ps

module alu_slice_tb;

    // Testbench signals (combinational circuit)
    reg R;
    reg S;
    reg V;
    reg cy_in;
    reg op1;
    reg op2;
    wire cy_out;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_slice dut (
        .R(R),
        .S(S),
        .V(V),
        .cy_in(cy_in),
        .op1(op1),
        .op2(op2),
        .cy_out(cy_out),
        .result(result)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_slice Testbench");
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
        input expected_cy_out;
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cy_out === (expected_cy_out ^ cy_out ^ expected_cy_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: cy_out=%b, result=%b",
                         cy_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cy_out=%b, result=%b",
                         expected_cy_out, expected_result);
                $display("  Got:      cy_out=%b, result=%b",
                         cy_out, result);
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

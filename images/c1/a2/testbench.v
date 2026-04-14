`timescale 1ns/1ps

module minus_one_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] i_operand;
    wire o_borrow;
    wire [15:0] o_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    minus_one dut (
        .i_operand(i_operand),
        .o_borrow(o_borrow),
        .o_result(o_result)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("minus_one Testbench");
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
        input expected_o_borrow;
        input [15:0] expected_o_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_borrow === (expected_o_borrow ^ o_borrow ^ expected_o_borrow) &&
                expected_o_result === (expected_o_result ^ o_result ^ expected_o_result)) begin
                $display("PASS");
                $display("  Outputs: o_borrow=%b, o_result=%h",
                         o_borrow, o_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_borrow=%b, o_result=%h",
                         expected_o_borrow, expected_o_result);
                $display("  Got:      o_borrow=%b, o_result=%h",
                         o_borrow, o_result);
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

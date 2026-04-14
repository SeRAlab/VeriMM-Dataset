`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] immjbr_upper_i;
    reg op_bf_i;
    reg op_bnf_i;
    wire predicted_flag_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .immjbr_upper_i(immjbr_upper_i),
        .op_bf_i(op_bf_i),
        .op_bnf_i(op_bnf_i),
        .predicted_flag_o(predicted_flag_o)
    );
    task testcase001;

        begin
            $display("Testcase 001: Branch Forward active, MSB of immediate set");
            op_bf_i = 1;
            op_bnf_i = 0;
            immjbr_upper_i = 10'b1000000000;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Branch Forward active, MSB of immediate not set");
            op_bf_i = 1;
            op_bnf_i = 0;
            immjbr_upper_i = 10'b0111111111;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Branch Not Taken active, MSB of immediate not set");
            op_bf_i = 0;
            op_bnf_i = 1;
            immjbr_upper_i = 10'b0000000000;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Branch Not Taken active, MSB of immediate set");
            op_bf_i = 0;
            op_bnf_i = 1;
            immjbr_upper_i = 10'b1010101010;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: No operations active");
            op_bf_i = 0;
            op_bnf_i = 0;
            immjbr_upper_i = 10'b1111111111;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Both BF and BNF active, MSB set (matches BF)");
            op_bf_i = 1;
            op_bnf_i = 1;
            immjbr_upper_i = 10'b1000000001;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Both BF and BNF active, MSB not set (matches BNF)");
            op_bf_i = 1;
            op_bnf_i = 1;
            immjbr_upper_i = 10'b0110011001;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: BF active, MSB set, lower bits variety");
            op_bf_i = 1;
            op_bnf_i = 0;
            immjbr_upper_i = 10'b1101101101;
            #1;

            check_outputs(1);
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
        testcase007();
        testcase008();
        
        
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
        input expected_predicted_flag_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_predicted_flag_o === (expected_predicted_flag_o ^ predicted_flag_o ^ expected_predicted_flag_o)) begin
                $display("PASS");
                $display("  Outputs: predicted_flag_o=%b",
                         predicted_flag_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_flag_o=%b",
                         expected_predicted_flag_o);
                $display("  Got:      predicted_flag_o=%b",
                         predicted_flag_o);
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

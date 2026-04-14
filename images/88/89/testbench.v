`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg C_i;
    reg Op_A_i;
    reg Op_B_i;
    wire C_o;
    wire P_o;
    wire S_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C_i(C_i),
        .Op_A_i(Op_A_i),
        .Op_B_i(Op_B_i),
        .C_o(C_o),
        .P_o(P_o),
        .S_o(S_o)
    );
    task testcase001;

        begin
            test_num = 1;
            Op_A_i = 1'b0; Op_B_i = 1'b0; C_i = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            Op_A_i = 1'b0; Op_B_i = 1'b0; C_i = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            Op_A_i = 1'b0; Op_B_i = 1'b1; C_i = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            Op_A_i = 1'b0; Op_B_i = 1'b1; C_i = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            Op_A_i = 1'b1; Op_B_i = 1'b0; C_i = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            Op_A_i = 1'b1; Op_B_i = 1'b0; C_i = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            Op_A_i = 1'b1; Op_B_i = 1'b1; C_i = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            Op_A_i = 1'b1; Op_B_i = 1'b1; C_i = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
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
        input expected_C_o;
        input expected_P_o;
        input expected_S_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_o === (expected_C_o ^ C_o ^ expected_C_o) &&
                expected_P_o === (expected_P_o ^ P_o ^ expected_P_o) &&
                expected_S_o === (expected_S_o ^ S_o ^ expected_S_o)) begin
                $display("PASS");
                $display("  Outputs: C_o=%b, P_o=%b, S_o=%b",
                         C_o, P_o, S_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_o=%b, P_o=%b, S_o=%b",
                         expected_C_o, expected_P_o, expected_S_o);
                $display("  Got:      C_o=%b, P_o=%b, S_o=%b",
                         C_o, P_o, S_o);
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

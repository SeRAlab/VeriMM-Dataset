`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bit0;
    reg bit1;
    wire ez_instance__state;
    wire parity0;
    wire parity1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bit0(bit0),
        .bit1(bit1),
        .ez_instance__state(ez_instance__state),
        .parity0(parity0),
        .parity1(parity1)
    );
    task testcase001;

        begin
            test_num = 1;
            bit1 = 1'b0;
            bit0 = 1'b0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            bit1 = 1'b0;
            bit0 = 1'b1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            bit1 = 1'b1;
            bit0 = 1'b0;


            #1;



            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            bit1 = 1'b1;
            bit0 = 1'b1;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_ez_instance__state;
        input expected_parity0;
        input expected_parity1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ez_instance__state === (expected_ez_instance__state ^ ez_instance__state ^ expected_ez_instance__state) &&
                expected_parity0 === (expected_parity0 ^ parity0 ^ expected_parity0) &&
                expected_parity1 === (expected_parity1 ^ parity1 ^ expected_parity1)) begin
                $display("PASS");
                $display("  Outputs: ez_instance__state=%b, parity0=%b, parity1=%b",
                         ez_instance__state, parity0, parity1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ez_instance__state=%b, parity0=%b, parity1=%b",
                         expected_ez_instance__state, expected_parity0, expected_parity1);
                $display("  Got:      ez_instance__state=%b, parity0=%b, parity1=%b",
                         ez_instance__state, parity0, parity1);
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

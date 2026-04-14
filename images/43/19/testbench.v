`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] WSTATE;
    wire [1:0] next_WSTATE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WSTATE(WSTATE),
        .next_WSTATE(next_WSTATE)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Transition from WIDLE (0) to WCB0 (1)", test_num);
            WSTATE = 2'b00;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition from WCB0 (1) to WIDLE (0)", test_num);
            WSTATE = 2'b01;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Invalid State (2) handling", test_num);
            WSTATE = 2'b10;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Invalid State (3) handling", test_num);
            WSTATE = 2'b11;

            #1;


            check_outputs(2'b00);
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
        input [1:0] expected_next_WSTATE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_WSTATE === (expected_next_WSTATE ^ next_WSTATE ^ expected_next_WSTATE)) begin
                $display("PASS");
                $display("  Outputs: next_WSTATE=%h",
                         next_WSTATE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_WSTATE=%h",
                         expected_next_WSTATE);
                $display("  Got:      next_WSTATE=%h",
                         next_WSTATE);
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

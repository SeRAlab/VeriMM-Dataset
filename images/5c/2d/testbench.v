`timescale 1ns/1ps

module logic_module_tb;

    // Testbench signals (combinational circuit)
    reg k;
    reg l;
    wire [3:0] mux_outputs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_module dut (
        .k(k),
        .l(l),
        .mux_outputs(mux_outputs)
    );
    task testcase001;

        begin
            test_num = 1;
            k = 1'b0;
            l = 1'b0;
            $display("Test Case 001: k=0, l=0");
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            k = 1'b0;
            l = 1'b1;
            $display("Test Case 002: k=0, l=1");
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            k = 1'b1;
            l = 1'b0;
            $display("Test Case 003: k=1, l=0");
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            k = 1'b1;
            l = 1'b1;
            $display("Test Case 004: k=1, l=1");
            #1;

            check_outputs(4'b0110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("logic_module Testbench");
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
        input [3:0] expected_mux_outputs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_outputs === (expected_mux_outputs ^ mux_outputs ^ expected_mux_outputs)) begin
                $display("PASS");
                $display("  Outputs: mux_outputs=%h",
                         mux_outputs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_outputs=%h",
                         expected_mux_outputs);
                $display("  Got:      mux_outputs=%h",
                         mux_outputs);
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

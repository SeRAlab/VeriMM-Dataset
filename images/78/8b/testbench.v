`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [31:0] o;
    wire [31:0] oe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .o(o),
        .oe(oe)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Initial value verification...", test_num);

            #1;


            check_outputs(32'h12345679, 32'hab345679);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Stability verification over time...", test_num);
            #100;
            #1;

            check_outputs(32'h12345679, 32'hab345679);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Long-term stability verification...", test_num);
            #500;
            #1;

            check_outputs(32'h12345679, 32'hab345679);
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
        input [31:0] expected_o;
        input [31:0] expected_oe;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o) &&
                expected_oe === (expected_oe ^ oe ^ expected_oe)) begin
                $display("PASS");
                $display("  Outputs: o=%h, oe=%h",
                         o, oe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h, oe=%h",
                         expected_o, expected_oe);
                $display("  Got:      o=%h, oe=%h",
                         o, oe);
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

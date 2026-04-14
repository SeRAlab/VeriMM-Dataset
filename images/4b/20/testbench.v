`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input_voltage;
    wire output_power;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_voltage(input_voltage),
        .output_power(output_power)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Zero Voltage", test_num);
            input_voltage = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Maximum Voltage", test_num);
            input_voltage = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Alternating Bits 1010", test_num);
            input_voltage = 8'hAA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Alternating Bits 0101", test_num);
            input_voltage = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Arbitrary Middle Value", test_num);
            input_voltage = 8'h3C;
            #1;

            check_outputs(8'h3C);
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
        input expected_output_power;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_power === (expected_output_power ^ output_power ^ expected_output_power)) begin
                $display("PASS");
                $display("  Outputs: output_power=%b",
                         output_power);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_power=%b",
                         expected_output_power);
                $display("  Got:      output_power=%b",
                         output_power);
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

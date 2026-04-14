`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    wire output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .enable(enable),
        .output_voltage(output_voltage)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: LDO Disabled (Initial State)");
            test_num = 1;
            enable = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: LDO Enabled");
            test_num = 2;
            enable = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Transition from Enabled to Disabled");
            test_num = 3;
            enable = 1;
            #10;
            enable = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Transition from Disabled to Enabled");
            test_num = 4;
            enable = 0;
            #10;
            enable = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Regulator Testbench");
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
        input expected_output_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: output_voltage=%b",
                         output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_voltage=%b",
                         expected_output_voltage);
                $display("  Got:      output_voltage=%b",
                         output_voltage);
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

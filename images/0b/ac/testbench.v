`timescale 1ns/1ps

module DAC_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary_input;
    wire [7:0] voltage_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_8bit dut (
        .binary_input(binary_input),
        .voltage_output(voltage_output)
    );
    task testcase001;

        begin
            $display("Testcase 001: Minimum input (Zero)");
            binary_input = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Maximum input (Full Scale)");
            binary_input = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Midpoint input (Power of 2)");
            binary_input = 8'h80;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Arbitrary pattern (Alternating bits)");
            binary_input = 8'hAA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Arbitrary pattern (Inverse alternating)");
            binary_input = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Small increment (Step 1)");
            binary_input = 8'h01;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: High range value");
            binary_input = 8'hFE;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Quarter scale");
            binary_input = 8'h40;
            #1;

            check_outputs(8'h40);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_8bit Testbench");
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
        input [7:0] expected_voltage_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_output === (expected_voltage_output ^ voltage_output ^ expected_voltage_output)) begin
                $display("PASS");
                $display("  Outputs: voltage_output=%h",
                         voltage_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_output=%h",
                         expected_voltage_output);
                $display("  Got:      voltage_output=%h",
                         voltage_output);
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

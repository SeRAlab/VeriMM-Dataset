`timescale 1ns/1ps

module DAC24_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    wire [23:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC24 dut (
        .digital_input(digital_input),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            $display("Test Case 001: Minimum Value (All Zeros)");
            digital_input = 24'h000000;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Maximum Value (All Ones)");
            digital_input = 24'hFFFFFF;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Midpoint Value (MSB only)");
            digital_input = 24'h800000;
            #1;

            check_outputs(24'h800000);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Alternating Bits Pattern A");
            digital_input = 24'hAAAAAA;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Alternating Bits Pattern 5");
            digital_input = 24'h555555;
            #1;

            check_outputs(24'h555555);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Random Arbitrary Value 1");
            digital_input = 24'h123456;
            #1;

            check_outputs(24'h123456);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Random Arbitrary Value 2");
            digital_input = 24'hABCDEF;
            #1;

            check_outputs(24'hABCDEF);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Walking bit test (Bit 12)");
            digital_input = 24'h001000;
            #1;

            check_outputs(24'h001000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC24 Testbench");
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
        input [23:0] expected_analog_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_output === (expected_analog_output ^ analog_output ^ expected_analog_output)) begin
                $display("PASS");
                $display("  Outputs: analog_output=%h",
                         analog_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_output=%h",
                         expected_analog_output);
                $display("  Got:      analog_output=%h",
                         analog_output);
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

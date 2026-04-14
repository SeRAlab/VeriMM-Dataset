`timescale 1ns/1ps

module DAC_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] binary_input;
    reg [15:0] reference_voltage;
    wire [15:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_16bit dut (
        .binary_input(binary_input),
        .reference_voltage(reference_voltage),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Minimum Input", test_num);
        binary_input = 16'h0000;
        reference_voltage = 16'hFFFF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum Input and Reference", test_num);
        binary_input = 16'hFFFF;
        reference_voltage = 16'hFFFF;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Mid-scale Input", test_num);
        binary_input = 16'h8000;
        reference_voltage = 16'hFFFF;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Mid-scale Reference", test_num);
        binary_input = 16'hFFFF;
        reference_voltage = 16'h8000;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Quarter-scale Input", test_num);
        binary_input = 16'h4000;
        reference_voltage = 16'hFFFF;
        #1;

        check_outputs(16'h3FFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Arbitrary Scaling", test_num);
        binary_input = 16'h1234;
        reference_voltage = 16'h5678;
        #1;

        check_outputs(16'h0626);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero Reference Voltage", test_num);
        binary_input = 16'hABCD;
        reference_voltage = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Minimum Non-Zero Input", test_num);
        binary_input = 16'h0001;
        reference_voltage = 16'hFFFF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_16bit Testbench");
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
        input [15:0] expected_analog_output;
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

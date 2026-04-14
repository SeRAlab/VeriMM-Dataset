`timescale 1ns/1ps

module vco_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] control_voltage;
    wire frequency_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vco dut (
        .control_voltage(control_voltage),
        .frequency_output(frequency_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Control Voltage = 0 (Expected Output: 0)", test_num);
            control_voltage = 3'b000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Control Voltage = 1 (Expected Output: 0)", test_num);
            control_voltage = 3'b001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Control Voltage = 2 (Expected Output: 0)", test_num);
            control_voltage = 3'b010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Control Voltage = 3 (Expected Output: 0)", test_num);
            control_voltage = 3'b011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Control Voltage = 4 (Expected Output: 1)", test_num);
            control_voltage = 3'b100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Control Voltage = 5 (Expected Output: 1)", test_num);
            control_voltage = 3'b101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Control Voltage = 6 (Expected Output: 1)", test_num);
            control_voltage = 3'b110;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Control Voltage = 7 (Expected Output: 1)", test_num);
            control_voltage = 3'b111;
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
        $display("vco Testbench");
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
        input expected_frequency_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_frequency_output === (expected_frequency_output ^ frequency_output ^ expected_frequency_output)) begin
                $display("PASS");
                $display("  Outputs: frequency_output=%b",
                         frequency_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_output=%b",
                         expected_frequency_output);
                $display("  Got:      frequency_output=%b",
                         frequency_output);
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

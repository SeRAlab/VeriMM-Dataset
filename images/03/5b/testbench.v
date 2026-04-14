`timescale 1ns/1ps

module adc_simulator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] analog_value;
    wire [15:0] digital_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_simulator dut (
        .analog_value(analog_value),
        .digital_value(digital_value)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero value", test_num);
            analog_value = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value", test_num);
            analog_value = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Midpoint MSB only", test_num);
            analog_value = 16'h8000;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Midpoint below MSB", test_num);
            analog_value = 16'h7FFF;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits pattern AAAA", test_num);
            analog_value = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits pattern 5555", test_num);
            analog_value = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random hex pattern 1234", test_num);
            analog_value = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random hex pattern ABCD", test_num);
            analog_value = 16'hABCD;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_simulator Testbench");
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
        input [15:0] expected_digital_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_value === (expected_digital_value ^ digital_value ^ expected_digital_value)) begin
                $display("PASS");
                $display("  Outputs: digital_value=%h",
                         digital_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_value=%h",
                         expected_digital_value);
                $display("  Got:      digital_value=%h",
                         digital_value);
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

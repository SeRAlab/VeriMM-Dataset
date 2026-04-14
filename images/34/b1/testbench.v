`timescale 1ns/1ps

module adc_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] voltage_input;
    wire [7:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8bit dut (
        .voltage_input(voltage_input),
        .digital_output(digital_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Minimum Voltage Input (0)");
            voltage_input = 3'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Voltage Input 1");
            voltage_input = 3'd1;
            #1;

            check_outputs(8'd32);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Voltage Input 2");
            voltage_input = 3'd2;
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Voltage Input 3 (Specification Example)");
            voltage_input = 3'd3;
            #1;

            check_outputs(8'd96);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Voltage Input 4");
            voltage_input = 3'd4;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Voltage Input 5");
            voltage_input = 3'd5;
            #1;

            check_outputs(8'd160);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Voltage Input 6");
            voltage_input = 3'd6;
            #1;

            check_outputs(8'd192);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Maximum Voltage Input (7)");
            voltage_input = 3'd7;
            #1;

            check_outputs(8'd224);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_8bit Testbench");
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
        input [7:0] expected_digital_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h",
                         digital_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h",
                         expected_digital_output);
                $display("  Got:      digital_output=%h",
                         digital_output);
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

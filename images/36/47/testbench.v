`timescale 1ns/1ps

module LinearVoltageRegulator_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] input_voltage;
    wire [7:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LinearVoltageRegulator dut (
        .enable(enable),
        .input_voltage(input_voltage),
        .output_voltage(output_voltage)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disabled - Zero Input", test_num);
            enable = 0;
            input_voltage = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enabled - Standard Input Voltage", test_num);
            enable = 1;
            input_voltage = 8'd200;
            #1;

            check_outputs(REGULATED_VAL);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enabled - Maximum Input Voltage", test_num);
            enable = 1;
            input_voltage = 8'd255;
            #1;

            check_outputs(REGULATED_VAL);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enabled - Low Input Voltage", test_num);
            enable = 1;
            input_voltage = 8'd130;
            #1;

            check_outputs(REGULATED_VAL);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disabled - High Input Voltage", test_num);
            enable = 0;
            input_voltage = 8'd250;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Enable state", test_num);

            enable = 1;
            input_voltage = 8'd150;
            #5;

            enable = 0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LinearVoltageRegulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_output_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: output_voltage=%h",
                         output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_voltage=%h",
                         expected_output_voltage);
                $display("  Got:      output_voltage=%h",
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

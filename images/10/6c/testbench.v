`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] reference_voltage;
    wire [7:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .enable(enable),
        .reference_voltage(reference_voltage),
        .output_voltage(output_voltage)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Enable low, high reference voltage");
            enable = 1'b0;
            reference_voltage = 8'hFF;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Enable high, zero reference voltage");
            enable = 1'b1;
            reference_voltage = 8'h00;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Enable high, mid-range reference voltage (0xA5)");
            enable = 1'b1;
            reference_voltage = 8'hA5;
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Enable high, max reference voltage (0xFF)");
            enable = 1'b1;
            reference_voltage = 8'hFF;
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Enable low, mid-range reference voltage (0x5A)");
            enable = 1'b0;
            reference_voltage = 8'h5A;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Enable high, alternating pattern (0x3C)");
            enable = 1'b1;
            reference_voltage = 8'h3C;
            #1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Enable high, alternating pattern (0xC3)");
            enable = 1'b1;
            reference_voltage = 8'hC3;
            #1;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Enable low, zero reference voltage");
            enable = 1'b0;
            reference_voltage = 8'h00;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
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

`timescale 1ns/1ps

module adc_converter_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [31:0] voltage_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_converter dut (
        .adc_input(adc_input),
        .voltage_output(voltage_output)
    );
    task testcase001;

    begin
        test_num = 1;
        adc_input = 24'h000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        adc_input = 24'h800000;
        #1;

        check_outputs(32'h000001A6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        adc_input = 24'hFFFFFF;
        #1;

        check_outputs(32'h0000034C);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        adc_input = 24'h400000;
        #1;

        check_outputs(32'h000000D3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        adc_input = 24'hC00000;
        #1;

        check_outputs(32'h00000279);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        adc_input = 24'h4D9365;
        #1;

        check_outputs(32'h00000100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        adc_input = 24'h004D94;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_converter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_voltage_output;
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

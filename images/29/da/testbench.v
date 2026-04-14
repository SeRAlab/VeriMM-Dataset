`timescale 1ns/1ps

module adc_processor_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [7:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_processor dut (
        .adc_input(adc_input),
        .digital_output(digital_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Minimum ADC input (0)", test_num);
        adc_input = 24'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Threshold Boundary (128)", test_num);
        adc_input = 24'd128;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Just above Threshold (129)", test_num);
        adc_input = 24'd129;
        #1;

        check_outputs(8'h81);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Value 256 (Lower 8 bits are 0)", test_num);
        adc_input = 24'd256;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Large value 0x000181", test_num);
        adc_input = 24'h000181;
        #1;

        check_outputs(8'h81);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: High value 0xABCDEF", test_num);
        adc_input = 24'hABCDEF;
        #1;

        check_outputs(8'hEF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Maximum 24-bit value", test_num);
        adc_input = 24'hFFFFFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Value 64 (Below threshold)", test_num);
        adc_input = 24'd64;
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
        $display("adc_processor Testbench");
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

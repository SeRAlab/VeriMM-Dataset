`timescale 1ns/1ps

module adc_processor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [15:0] adc_output;
    wire is_above_threshold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_processor dut (
        .adc_input(adc_input),
        .adc_output(adc_output),
        .is_above_threshold(is_above_threshold)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Minimum Value", test_num);
        adc_input = 16'h0000;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Below Threshold Boundary", test_num);
        adc_input = 16'h7FFF;
        #1;

        check_outputs(16'h7FFF, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Exactly at Threshold", test_num);
        adc_input = 16'h8000;
        #1;

        check_outputs(16'h8000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Just Above Threshold", test_num);
        adc_input = 16'h8001;
        #1;

        check_outputs(16'h8001, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Arbitrary High Value", test_num);
        adc_input = 16'hABCD;
        #1;

        check_outputs(16'hABCD, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Maximum Value", test_num);
        adc_input = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Arbitrary Low Value", test_num);
        adc_input = 16'h1234;
        #1;

        check_outputs(16'h1234, 1'b0);
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
        input [15:0] expected_adc_output;
        input expected_is_above_threshold;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adc_output === (expected_adc_output ^ adc_output ^ expected_adc_output) &&
                expected_is_above_threshold === (expected_is_above_threshold ^ is_above_threshold ^ expected_is_above_threshold)) begin
                $display("PASS");
                $display("  Outputs: adc_output=%h, is_above_threshold=%b",
                         adc_output, is_above_threshold);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_output=%h, is_above_threshold=%b",
                         expected_adc_output, expected_is_above_threshold);
                $display("  Got:      adc_output=%h, is_above_threshold=%b",
                         adc_output, is_above_threshold);
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

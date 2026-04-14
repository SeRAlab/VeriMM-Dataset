`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_output;
    reg [15:0] reference_value;
    wire comparator_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .adc_output(adc_output),
        .reference_value(reference_value),
        .comparator_out(comparator_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ADC Output (0) < Reference (1000)", test_num);
        adc_output = 16'd0;
        reference_value = 16'd1000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ADC Output (2000) > Reference (1000)", test_num);
        adc_output = 16'd2000;
        reference_value = 16'd1000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ADC Output (1500) == Reference (1500)", test_num);
        adc_output = 16'd1500;
        reference_value = 16'd1500;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max ADC Output (65535) > Min Reference (0)", test_num);
        adc_output = 16'hFFFF;
        reference_value = 16'h0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min ADC Output (0) < Max Reference (65535)", test_num);
        adc_output = 16'h0000;
        reference_value = 16'hFFFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary - ADC Output (32769) > Reference (32768)", test_num);
        adc_output = 16'd32769;
        reference_value = 16'd32768;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary - ADC Output (32767) < Reference (32768)", test_num);
        adc_output = 16'd32767;
        reference_value = 16'd32768;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones comparison (65535 == 65535)", test_num);
        adc_output = 16'hFFFF;
        reference_value = 16'hFFFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_comparator Testbench");
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
        input expected_comparator_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comparator_out === (expected_comparator_out ^ comparator_out ^ expected_comparator_out)) begin
                $display("PASS");
                $display("  Outputs: comparator_out=%b",
                         comparator_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comparator_out=%b",
                         expected_comparator_out);
                $display("  Got:      comparator_out=%b",
                         comparator_out);
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

`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_output;
    reg [15:0] reference_value;
    wire equal;
    wire greater;
    wire less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .adc_output(adc_output),
        .reference_value(reference_value),
        .equal(equal),
        .greater(greater),
        .less(less)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality at Zero", test_num);
            adc_output = 16'h0000;
            reference_value = 16'h0000;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality at Maximum Value", test_num);
            adc_output = 16'hFFFF;
            reference_value = 16'hFFFF;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality at Mid-range Value", test_num);
            adc_output = 16'h7ABC;
            reference_value = 16'h7ABC;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADC Output Greater (Standard)", test_num);
            adc_output = 16'hA000;
            reference_value = 16'h8000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADC Output Less (Standard)", test_num);
            adc_output = 16'h4000;
            reference_value = 16'h6000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADC Output Greater (Max vs Min)", test_num);
            adc_output = 16'hFFFF;
            reference_value = 16'h0000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADC Output Less (Min vs Max)", test_num);
            adc_output = 16'h0000;
            reference_value = 16'hFFFF;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADC Output Greater (Diff by 1)", test_num);
            adc_output = 16'h8001;
            reference_value = 16'h8000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADC Output Less (Diff by 1)", test_num);
            adc_output = 16'h7FFF;
            reference_value = 16'h8000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Patterns", test_num);
            adc_output = 16'hAAAA;
            reference_value = 16'h5555;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_equal;
        input expected_greater;
        input expected_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater === (expected_greater ^ greater ^ expected_greater) &&
                expected_less === (expected_less ^ less ^ expected_less)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater=%b, less=%b",
                         equal, greater, less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater=%b, less=%b",
                         expected_equal, expected_greater, expected_less);
                $display("  Got:      equal=%b, greater=%b, less=%b",
                         equal, greater, less);
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

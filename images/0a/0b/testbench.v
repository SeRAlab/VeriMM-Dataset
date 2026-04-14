`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_value;
    reg [15:0] threshold;
    wire equal;
    wire greater;
    wire less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .adc_value(adc_value),
        .threshold(threshold),
        .equal(equal),
        .greater(greater),
        .less(less)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Both Zero (Equal)", test_num);
        adc_value = 16'd0;
        threshold = 16'd0;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: ADC Greater than Threshold (Mid Range)", test_num);
        adc_value = 16'd500;
        threshold = 16'd100;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: ADC Less than Threshold (Mid Range)", test_num);
        adc_value = 16'd250;
        threshold = 16'd750;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Maximum Values (Equal)", test_num);
        adc_value = 16'hFFFF;
        threshold = 16'hFFFF;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: ADC Max, Threshold Min (Greater)", test_num);
        adc_value = 16'hFFFF;
        threshold = 16'h0000;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: ADC Min, Threshold Max (Less)", test_num);
        adc_value = 16'h0000;
        threshold = 16'hFFFF;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Unsigned Comparison Boundary (Greater)", test_num);

        adc_value = 16'h8000;
        threshold = 16'h7FFF;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Unsigned Comparison Boundary (Less)", test_num);
        adc_value = 16'h7FFF;
        threshold = 16'h8000;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Near Equality (ADC = Threshold + 1)", test_num);
        threshold = 16'd12345;
        adc_value = 16'd12346;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Near Equality (ADC = Threshold - 1)", test_num);
        threshold = 16'd12345;
        adc_value = 16'd12344;
        #1;

        check_outputs(0, 0, 1);
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

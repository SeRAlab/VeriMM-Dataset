`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_output;
    reg [23:0] reference_value;
    wire [1:0] comparison_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .adc_output(adc_output),
        .reference_value(reference_value),
        .comparison_result(comparison_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal (Zero)", test_num);
            adc_output = 24'h000000;
            reference_value = 24'h000000;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal (Maximum)", test_num);
            adc_output = 24'hFFFFFF;
            reference_value = 24'hFFFFFF;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal (Middle)", test_num);
            adc_output = 24'hABCDEF;
            reference_value = 24'hABCDEF;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Less Than (Small vs Small+1)", test_num);
            adc_output = 24'h000000;
            reference_value = 24'h000001;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Greater Than (Small+1 vs Small)", test_num);
            adc_output = 24'h000001;
            reference_value = 24'h000000;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Less Than (Max-1 vs Max)", test_num);
            adc_output = 24'hFFFFFE;
            reference_value = 24'hFFFFFF;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Greater Than (Max vs Max-1)", test_num);
            adc_output = 24'hFFFFFF;
            reference_value = 24'hFFFFFE;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Greater Than (MSB difference)", test_num);
            adc_output = 24'h800000;
            reference_value = 24'h7FFFFF;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Less Than (MSB difference)", test_num);
            adc_output = 24'h7FFFFF;
            reference_value = 24'h800000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary comparison", test_num);
            adc_output = 24'h123456;
            reference_value = 24'h654321;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_comparison_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comparison_result === (expected_comparison_result ^ comparison_result ^ expected_comparison_result)) begin
                $display("PASS");
                $display("  Outputs: comparison_result=%h",
                         comparison_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comparison_result=%h",
                         expected_comparison_result);
                $display("  Got:      comparison_result=%h",
                         comparison_result);
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

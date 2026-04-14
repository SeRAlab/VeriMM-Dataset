`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_value;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .adc_value(adc_value),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            adc_value = 24'd0;
            $display("Test Case %0d: Input = %0d (Minimum Value)", test_num, adc_value);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            adc_value = 24'd12345677;
            $display("Test Case %0d: Input = %0d (Reference - 1)", test_num, adc_value);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            adc_value = 24'd12345678;
            $display("Test Case %0d: Input = %0d (Equal to Reference)", test_num, adc_value);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            adc_value = 24'd12345679;
            $display("Test Case %0d: Input = %0d (Reference + 1)", test_num, adc_value);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            adc_value = 24'd16777215;
            $display("Test Case %0d: Input = %0d (Maximum Value)", test_num, adc_value);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            adc_value = 24'd5000000;
            $display("Test Case %0d: Input = %0d", test_num, adc_value);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            adc_value = 24'd14000000;
            $display("Test Case %0d: Input = %0d", test_num, adc_value);
            #1;

            check_outputs(1'b1);
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
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%b",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%b",
                         expected_result);
                $display("  Got:      result=%b",
                         result);
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

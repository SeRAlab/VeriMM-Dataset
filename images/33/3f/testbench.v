`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] ADC1;
    reg [23:0] ADC2;
    wire greater;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .ADC1(ADC1),
        .ADC2(ADC2),
        .greater(greater)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Both inputs zero", test_num);
            ADC1 = 24'h000000;
            ADC2 = 24'h000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Both inputs maximum", test_num);
            ADC1 = 24'hFFFFFF;
            ADC2 = 24'hFFFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: ADC1 > ADC2 (LSB diff)", test_num);
            ADC1 = 24'h000001;
            ADC2 = 24'h000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: ADC2 > ADC1 (LSB diff)", test_num);
            ADC1 = 24'h000000;
            ADC2 = 24'h000001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: ADC1 > ADC2 (MSB diff)", test_num);
            ADC1 = 24'h800000;
            ADC2 = 24'h7FFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: ADC2 > ADC1 (MSB diff)", test_num);
            ADC1 = 24'h7FFFFF;
            ADC2 = 24'h800000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max vs Zero", test_num);
            ADC1 = 24'hFFFFFF;
            ADC2 = 24'h000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero vs Max", test_num);
            ADC1 = 24'h000000;
            ADC2 = 24'hFFFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pattern A5A5A5 vs 5A5A5A", test_num);
            ADC1 = 24'hA5A5A5;
            ADC2 = 24'h5A5A5A;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FFFFFF vs FFFFEE", test_num);
            ADC1 = 24'hFFFFFF;
            ADC2 = 24'hFFFFEE;
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
        input expected_greater;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_greater === (expected_greater ^ greater ^ expected_greater)) begin
                $display("PASS");
                $display("  Outputs: greater=%b",
                         greater);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater=%b",
                         expected_greater);
                $display("  Got:      greater=%b",
                         greater);
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

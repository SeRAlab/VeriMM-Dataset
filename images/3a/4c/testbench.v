`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc1;
    reg [15:0] adc2;
    wire [1:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .adc1(adc1),
        .adc2(adc2),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros (Equality)", test_num);
            adc1 = 16'h0000;
            adc2 = 16'h0000;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones (Equality)", test_num);
            adc1 = 16'hFFFF;
            adc2 = 16'hFFFF;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: ADC1 < ADC2 (Min vs Max)", test_num);
            adc1 = 16'h0000;
            adc2 = 16'hFFFF;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: ADC1 > ADC2 (Max vs Min)", test_num);
            adc1 = 16'hFFFF;
            adc2 = 16'h0000;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: ADC1 < ADC2 (Near boundary)", test_num);
            adc1 = 16'h7FFF;
            adc2 = 16'h8000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: ADC1 > ADC2 (Near boundary)", test_num);
            adc1 = 16'h8000;
            adc2 = 16'h7FFF;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: ADC1 = ADC2 (Middle value)", test_num);
            adc1 = 16'hA5A5;
            adc2 = 16'hA5A5;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: ADC1 < ADC2 (Single bit difference LSB)", test_num);
            adc1 = 16'h1234;
            adc2 = 16'h1235;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: ADC1 > ADC2 (Single bit difference MSB)", test_num);
            adc1 = 16'hC000;
            adc2 = 16'h4000;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Randomized mid-range check", test_num);
            adc1 = 16'h5555;
            adc2 = 16'hAAAA;
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
        input [1:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
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

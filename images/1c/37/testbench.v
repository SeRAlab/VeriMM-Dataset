`timescale 1ns/1ps

module adc_processor_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_value;
    wire half_flag;
    wire [11:0] scaled_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_processor dut (
        .adc_value(adc_value),
        .half_flag(half_flag),
        .scaled_value(scaled_value)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Minimum ADC Value", test_num);
            adc_value = 24'h000000;


            #1;



            check_outputs(1'b0, 12'h800);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Maximum ADC Value", test_num);
            adc_value = 24'hFFFFFF;


            #1;



            check_outputs(1'b1, 12'h7FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Mid-point ADC Value (Zero Scaled)", test_num);
            adc_value = 24'h800000;


            #1;



            check_outputs(1'b0, 12'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Boundary Value 127", test_num);

            adc_value = 24'h87F000;


            #1;



            check_outputs(1'b0, 12'h07F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Boundary Value 128", test_num);

            adc_value = 24'h880000;


            #1;



            check_outputs(1'b1, 12'h080);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Negative Scaled Value (-100)", test_num);

            adc_value = 24'h79C555;


            #1;



            check_outputs(1'b0, 12'hF9C);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Positive Scaled Value (1000)", test_num);

            adc_value = 24'hBE8AAA;


            #1;



            check_outputs(1'b1, 12'h3E8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Scaled Value -1", test_num);

            adc_value = 24'h7FF000;


            #1;



            check_outputs(1'b0, 12'hFFF);
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
        input expected_half_flag;
        input [11:0] expected_scaled_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_half_flag === (expected_half_flag ^ half_flag ^ expected_half_flag) &&
                expected_scaled_value === (expected_scaled_value ^ scaled_value ^ expected_scaled_value)) begin
                $display("PASS");
                $display("  Outputs: half_flag=%b, scaled_value=%h",
                         half_flag, scaled_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: half_flag=%b, scaled_value=%h",
                         expected_half_flag, expected_scaled_value);
                $display("  Got:      half_flag=%b, scaled_value=%h",
                         half_flag, scaled_value);
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

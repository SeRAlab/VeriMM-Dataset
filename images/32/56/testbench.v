`timescale 1ns/1ps

module adc_threshold_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_value;
    wire threshold_exceeded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_threshold dut (
        .adc_value(adc_value),
        .threshold_exceeded(threshold_exceeded)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum value (0x0000)", test_num);
            adc_value = 16'h0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Just below threshold (0x7FFF)", test_num);
            adc_value = 16'h7FFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Exactly at threshold (0x8000)", test_num);
            adc_value = 16'h8000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Just above threshold (0x8001)", test_num);
            adc_value = 16'h8001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum value (0xFFFF)", test_num);
            adc_value = 16'hFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random low value (0x1234)", test_num);
            adc_value = 16'h1234;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random high value (0xABCD)", test_num);
            adc_value = 16'hABCD;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Middle of lower range (0x4000)", test_num);
            adc_value = 16'h4000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Middle of upper range (0xC000)", test_num);
            adc_value = 16'hC000;
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
        $display("adc_threshold Testbench");
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
        input expected_threshold_exceeded;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_threshold_exceeded === (expected_threshold_exceeded ^ threshold_exceeded ^ expected_threshold_exceeded)) begin
                $display("PASS");
                $display("  Outputs: threshold_exceeded=%b",
                         threshold_exceeded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: threshold_exceeded=%b",
                         expected_threshold_exceeded);
                $display("  Got:      threshold_exceeded=%b",
                         threshold_exceeded);
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

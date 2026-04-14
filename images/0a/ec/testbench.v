`timescale 1ns/1ps

module adc_16_to_4_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [3:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_16_to_4 dut (
        .adc_input(adc_input),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Minimum value (0)", test_num);
            adc_input = 16'h0000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Boundary of quantized value 0 (4095)", test_num);
            adc_input = 16'h0FFF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Start of quantized value 1 (4096)", test_num);
            adc_input = 16'h1000;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Power of 2 midpoint (16384)", test_num);
            adc_input = 16'h4000;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Center value (32768)", test_num);
            adc_input = 16'h8000;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Value 11 boundary (49151)", test_num);
            adc_input = 16'hBFFF;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Start of quantized value 15 (61440)", test_num);
            adc_input = 16'hF000;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Maximum value (65535)", test_num);
            adc_input = 16'hFFFF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest Case %0d: Patterned value (0xA5A5)", test_num);
            adc_input = 16'hA5A5;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTest Case %0d: Arbitrary value (0x1234)", test_num);
            adc_input = 16'h1234;
            #1;

            check_outputs(4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_16_to_4 Testbench");
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
        input [3:0] expected_adc_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adc_output === (expected_adc_output ^ adc_output ^ expected_adc_output)) begin
                $display("PASS");
                $display("  Outputs: adc_output=%h",
                         adc_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_output=%h",
                         expected_adc_output);
                $display("  Got:      adc_output=%h",
                         adc_output);
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

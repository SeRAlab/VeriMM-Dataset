`timescale 1ns/1ps

module adc_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [3:0] quantized_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_16bit dut (
        .adc_input(adc_input),
        .quantized_output(quantized_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum value", test_num);
            adc_input = 16'h0000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum value (Saturation check)", test_num);
            adc_input = 16'hFFFF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Level 0 (Max of Level 0)", test_num);
            adc_input = 16'd4095;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Level 1 (Min of Level 1)", test_num);
            adc_input = 16'd4096;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Midpoint of range", test_num);
            adc_input = 16'd32768;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High range boundary (End of Level 14)", test_num);
            adc_input = 16'd61439;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High range boundary (Start of Level 15)", test_num);
            adc_input = 16'd61440;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary value check", test_num);
            adc_input = 16'hA5A5;
            #1;

            check_outputs(4'hA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_16bit Testbench");
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
        input [3:0] expected_quantized_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quantized_output === (expected_quantized_output ^ quantized_output ^ expected_quantized_output)) begin
                $display("PASS");
                $display("  Outputs: quantized_output=%h",
                         quantized_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quantized_output=%h",
                         expected_quantized_output);
                $display("  Got:      quantized_output=%h",
                         quantized_output);
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

`timescale 1ns/1ps

module adc_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [15:0] decimal_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_decoder dut (
        .adc_input(adc_input),
        .decimal_output(decimal_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Minimum value (Zero)");
            adc_input = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Maximum value (65535)");
            adc_input = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Simple integer 1");
            adc_input = 16'd1;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Mid-range value (32768)");
            adc_input = 16'h8000;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Alternating bits (AAAA)");
            adc_input = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Alternating bits (5555)");
            adc_input = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Random integer 12345");
            adc_input = 16'd12345;
            #1;

            check_outputs(16'd12345);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Low byte set");
            adc_input = 16'h00FF;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: High byte set");
            adc_input = 16'hFF00;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Typical ADC value (e.g., 2.5V on 5V scale)");
            adc_input = 16'h7FFF;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_decoder Testbench");
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
        input [15:0] expected_decimal_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decimal_output === (expected_decimal_output ^ decimal_output ^ expected_decimal_output)) begin
                $display("PASS");
                $display("  Outputs: decimal_output=%h",
                         decimal_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decimal_output=%h",
                         expected_decimal_output);
                $display("  Got:      decimal_output=%h",
                         decimal_output);
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

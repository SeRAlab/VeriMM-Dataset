`timescale 1ns/1ps

module adc_interface_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    reg valid;
    wire [11:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_interface dut (
        .adc_input(adc_input),
        .valid(valid),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            $display("Testcase 001: Basic update when valid is high");
            test_num = test_num + 1;

            valid = 1;
            adc_input = 24'hABCDEF;
            #10;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Hold value when valid is low");
            test_num = test_num + 1;

            valid = 1;
            adc_input = 24'h123456;
            #10;

            valid = 0;
            adc_input = 24'hFFFFFF;
            #10;

            #1;


            check_outputs(12'h123);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Update from hold state");
            test_num = test_num + 1;


            adc_input = 24'hFEDCBA;
            valid = 1;
            #10;
            #1;

            check_outputs(12'hFED);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All ones boundary check");
            test_num = test_num + 1;
            valid = 1;
            adc_input = 24'hFFFFFF;
            #10;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All zeros boundary check");
            test_num = test_num + 1;
            valid = 1;
            adc_input = 24'h000000;
            #10;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify lower 12 bits do not affect output");
            test_num = test_num + 1;
            valid = 1;

            adc_input = 24'h5AA000;
            #10;
            adc_input = 24'h5AAFFF;
            #10;
            #1;

            check_outputs(12'h5AA);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiple toggles of valid signal");
            test_num = test_num + 1;

            adc_input = 24'h888123;
            valid = 1;
            #10;

            valid = 0;
            adc_input = 24'h999ABC;
            #10;

            valid = 1;
            #10;
            #1;

            check_outputs(12'h999);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_interface Testbench");
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
        input [11:0] expected_adc_output;
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

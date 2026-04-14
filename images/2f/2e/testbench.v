`timescale 1ns/1ps

module adc_24_to_12_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [11:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_24_to_12 dut (
        .adc_input(adc_input),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: All Zeros");
            adc_input = 24'h000000;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: All Ones");
            adc_input = 24'hFFFFFF;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Lower 12 bits set, Upper 12 bits zero");
            adc_input = 24'h000FFF;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Lower 12 bits zero, Upper 12 bits set");
            adc_input = 24'hFFF000;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Hex pattern ABCDEF");
            adc_input = 24'hABCDEF;
            #1;

            check_outputs(12'hDEF);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: Hex pattern 123456");
            adc_input = 24'h123456;
            #1;

            check_outputs(12'h456);
        end
        endtask

    task testcase007;

        begin
            $display("\nTest Case 007: Alternating bits (A)");
            adc_input = 24'hAAAAAA;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase008;

        begin
            $display("\nTest Case 008: Alternating bits (5)");
            adc_input = 24'h555555;
            #1;

            check_outputs(12'h555);
        end
        endtask

    task testcase009;

        begin
            $display("\nTest Case 009: Specific bit boundary check (bit 11 and 12)");
            adc_input = 24'h001800;
            #1;

            check_outputs(12'h800);
        end
        endtask

    task testcase010;

        begin
            $display("\nTest Case 010: High value upper, low value lower");
            adc_input = 24'hE7D21B;
            #1;

            check_outputs(12'h21B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_24_to_12 Testbench");
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

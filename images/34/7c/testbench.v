`timescale 1ns/1ps

module adc_to_digital_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [7:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_to_digital dut (
        .adc_input(adc_input),
        .digital_output(digital_output)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Minimum input (0)");
            test_num = 1;
            adc_input = 24'h000000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Round down threshold (0.499...)");
            test_num = 2;
            adc_input = 24'h007FFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Round up threshold (exactly 0.5)");
            test_num = 3;
            adc_input = 24'h008000;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Exact integer value (1.0)");
            test_num = 4;
            adc_input = 24'h010000;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Mid-range value round down");
            test_num = 5;
            adc_input = 24'h7F7FFF;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Mid-range value round up");
            test_num = 6;
            adc_input = 24'h7F8000;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Exact mid-range integer (128.0)");
            test_num = 7;
            adc_input = 24'h800000;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: High range integer (255.0)");
            test_num = 8;
            adc_input = 24'hFF0000;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            $display("\nTestcase 009: Maximum input within 8-bit range (255.499...)");
            test_num = 9;
            adc_input = 24'hFF7FFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            $display("\nTestcase 010: Arbitrary scaling check (10.0)");
            test_num = 10;
            adc_input = 24'h0A0000;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_to_digital Testbench");
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
        input [7:0] expected_digital_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h",
                         digital_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h",
                         expected_digital_output);
                $display("  Got:      digital_output=%h",
                         digital_output);
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

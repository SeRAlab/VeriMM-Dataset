`timescale 1ns/1ps

module adc_24_to_12_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    reg enable;
    wire [11:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_24_to_12 dut (
        .adc_input(adc_input),
        .enable(enable),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Conversion (Enable High)", test_num);
            enable = 1'b1;
            adc_input = 24'h000ABC;
            #5;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Truncation Check (Upper bits ignored)", test_num);
            enable = 1'b1;
            adc_input = 24'hFFF123;
            #5;
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Enable Low (Output should not change when input changes)", test_num);

            enable = 1'b1;
            adc_input = 24'h000555;
            #5;

            enable = 1'b0;
            #5;

            adc_input = 24'hAAAAAA;
            #5;
            #1;

            check_outputs(12'h555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: All Zeros Input", test_num);
            enable = 1'b1;
            adc_input = 24'h000000;
            #5;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: All Ones Input", test_num);
            enable = 1'b1;
            adc_input = 24'hFFFFFF;
            #5;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Alternating Bits Conversion", test_num);
            enable = 1'b1;
            adc_input = 24'hAAAAAA;
            #5;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Enable Toggle and Data Latency", test_num);

            enable = 1'b0;
            adc_input = 24'h123456;
            #5;

            enable = 1'b1;
            #5;
            #1;

            check_outputs(12'h456);
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

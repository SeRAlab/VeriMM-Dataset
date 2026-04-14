`timescale 1ns/1ps

module adc_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] adc_input;
    reg valid;
    wire [7:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8bit dut (
        .adc_input(adc_input),
        .valid(valid),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Valid=0, Data=10'h3FF (Expect 0)", test_num);
            valid = 0;
            adc_input = 10'h3FF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Valid=1, Data=10'h000 (Expect 0)", test_num);
            valid = 1;
            adc_input = 10'h000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Valid=1, Data=10'h3FF (Expect 0xFF)", test_num);
            valid = 1;
            adc_input = 10'h3FF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Valid=1, Data=10'h007 (Truncation Check: Expect 1)", test_num);
            valid = 1;
            adc_input = 10'h007;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Valid=1, Data=10'h155 (Truncation Check: Expect 0x55)", test_num);
            valid = 1;
            adc_input = 10'h155;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Valid=1, Data=10'h2AA (Truncation Check: Expect 0xAA)", test_num);
            valid = 1;
            adc_input = 10'h2AA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Valid signal (Check 0 when invalid)", test_num);
            valid = 1;
            adc_input = 10'h123;
            #5;
            valid = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_8bit Testbench");
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
        input [7:0] expected_adc_output;
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

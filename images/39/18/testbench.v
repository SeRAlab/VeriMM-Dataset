`timescale 1ns/1ps

module adc_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    reg enable;
    wire [23:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_24bit dut (
        .adc_input(adc_input),
        .enable(enable),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable low, input high", test_num);
            enable = 1'b0;
            adc_input = 24'hFFFFFF;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input 16 (0x10)", test_num);
            enable = 1'b1;
            adc_input = 24'h000010;
            #1;

            check_outputs(24'h000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input max (0xFFFFFF)", test_num);
            enable = 1'b1;
            adc_input = 24'hFFFFFF;
            #1;

            check_outputs(24'h0FFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input 0x123456", test_num);
            enable = 1'b1;
            adc_input = 24'h123456;
            #1;

            check_outputs(24'h012345);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input smaller than 16 (0x000008)", test_num);
            enable = 1'b1;
            adc_input = 24'h000008;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Toggle enable with constant input", test_num);
            adc_input = 24'hABCDEF;
            enable = 1'b0;
            #5;
            enable = 1'b1;
            #1;

            check_outputs(24'h0ABCDE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable high, input 0x800000", test_num);
            enable = 1'b1;
            adc_input = 24'h800000;
            #1;

            check_outputs(24'h080000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_24bit Testbench");
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
        input [23:0] expected_adc_output;
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

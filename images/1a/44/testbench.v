`timescale 1ns/1ps

module adc_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_value;
    wire [2:0] range;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_decoder dut (
        .adc_value(adc_value),
        .range(range)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower boundary of Range 0 (0x000000)", test_num);
            adc_value = 24'h000000;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper boundary of Range 0 (0x7FFFFF)", test_num);
            adc_value = 24'h7FFFFF;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower boundary of Range 1 (0x800000)", test_num);
            adc_value = 24'h800000;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper boundary of Range 1 (0xFFFFFF)", test_num);
            adc_value = 24'hFFFFFF;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random value in Range 0 (0x123456)", test_num);
            adc_value = 24'h123456;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random value in Range 1 (0xABCDEF)", test_num);
            adc_value = 24'hABCDEF;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Midpoint of Range 0 (0x3FFFFF)", test_num);
            adc_value = 24'h3FFFFF;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Midpoint of Range 1 (0xBFFFFF)", test_num);
            adc_value = 24'hBFFFFF;
            #1;

            check_outputs(3'd1);
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
        input [2:0] expected_range;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_range === (expected_range ^ range ^ expected_range)) begin
                $display("PASS");
                $display("  Outputs: range=%h",
                         range);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: range=%h",
                         expected_range);
                $display("  Got:      range=%h",
                         range);
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

`timescale 1ns/1ps

module adc_16_to_5_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [4:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_16_to_5 dut (
        .adc_input(adc_input),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum input (0)", test_num);
            adc_input = 16'h0000;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary below 2048 (2047)", test_num);
            adc_input = 16'd2047;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exact threshold for 1 (2048)", test_num);
            adc_input = 16'd2048;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary below 4096 (4095)", test_num);
            adc_input = 16'd4095;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exact threshold for 2 (4096)", test_num);
            adc_input = 16'd4096;
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle range value (10000)", test_num);

            adc_input = 16'd10000;
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 value (32768)", test_num);

            adc_input = 16'd32768;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High range value (50000)", test_num);

            adc_input = 16'd50000;
            #1;

            check_outputs(5'd24);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Threshold for maximum output 31 (63488)", test_num);

            adc_input = 16'd63488;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible 16-bit input (65535)", test_num);

            adc_input = 16'hFFFF;
            #1;

            check_outputs(5'd31);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_16_to_5 Testbench");
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
        input [4:0] expected_adc_output;
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

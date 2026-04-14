`timescale 1ns/1ps

module ThermalSensorCalibrator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] gain;
    reg [5:0] offset;
    reg [9:0] raw_input;
    wire [11:0] calibrated_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ThermalSensorCalibrator dut (
        .gain(gain),
        .offset(offset),
        .raw_input(raw_input),
        .calibrated_output(calibrated_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            raw_input = 10'd0;
            gain = 4'd0;
            offset = 6'd0;

            #1;


            check_outputs(12'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gain of 1, no offset", test_num);
            raw_input = 10'd500;
            gain = 4'd1;
            offset = 6'd0;

            #1;


            check_outputs(12'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gain of 0, positive offset", test_num);
            raw_input = 10'd1023;
            gain = 4'd0;
            offset = 6'd45;

            #1;


            check_outputs(12'd45);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Typical calculation", test_num);
            raw_input = 10'd128;
            gain = 4'd5;
            offset = 6'd20;

            #1;


            check_outputs(12'd660);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum offset", test_num);
            raw_input = 10'd10;
            gain = 4'd2;
            offset = 6'd63;

            #1;


            check_outputs(12'd83);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max raw input with gain", test_num);
            raw_input = 10'd1023;
            gain = 4'd3;
            offset = 6'd10;

            #1;


            check_outputs(12'd3079);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result at boundary (4095)", test_num);
            raw_input = 10'd504;
            gain = 4'd8;
            offset = 6'd63;

            #1;


            check_outputs(12'd4095);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow check (Truncation to 12 bits)", test_num);
            raw_input = 10'd1023;
            gain = 4'd15;
            offset = 6'd63;



            #1;




            check_outputs(12'hC30);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ThermalSensorCalibrator Testbench");
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
        input [11:0] expected_calibrated_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_calibrated_output === (expected_calibrated_output ^ calibrated_output ^ expected_calibrated_output)) begin
                $display("PASS");
                $display("  Outputs: calibrated_output=%h",
                         calibrated_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_output=%h",
                         expected_calibrated_output);
                $display("  Got:      calibrated_output=%h",
                         calibrated_output);
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

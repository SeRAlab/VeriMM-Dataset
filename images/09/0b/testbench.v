`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] offset;
    reg [9:0] temp_input;
    wire [9:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .offset(offset),
        .temp_input(temp_input),
        .calibrated_temp(calibrated_temp)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Addition", test_num);
            temp_input = 10'd100;
            offset = 10'd50;
            #1;

            check_outputs(10'd150);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Input Temperature", test_num);
            temp_input = 10'd0;
            offset = 10'd256;
            #1;

            check_outputs(10'd256);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Offset", test_num);
            temp_input = 10'd789;
            offset = 10'd0;
            #1;

            check_outputs(10'd789);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Addition (No Overflow)", test_num);
            temp_input = 10'd512;
            offset = 10'd511;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Bit Overflow", test_num);
            temp_input = 10'd1023;
            offset = 10'd1;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values Overflow", test_num);
            temp_input = 10'h3FF;
            offset = 10'h3FF;

            #1;


            check_outputs(10'h3FE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range Overflow", test_num);
            temp_input = 10'd600;
            offset = 10'd600;

            #1;


            check_outputs(10'd176);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Case", test_num);
            temp_input = 10'd0;
            offset = 10'd0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bit Pattern Check", test_num);
            temp_input = 10'b1010101010;
            offset = 10'b0101010101;
            #1;

            check_outputs(10'b1111111111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("thermal_sensor_calibration Testbench");
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
        input [9:0] expected_calibrated_temp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_calibrated_temp === (expected_calibrated_temp ^ calibrated_temp ^ expected_calibrated_temp)) begin
                $display("PASS");
                $display("  Outputs: calibrated_temp=%h",
                         calibrated_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_temp=%h",
                         expected_calibrated_temp);
                $display("  Got:      calibrated_temp=%h",
                         calibrated_temp);
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

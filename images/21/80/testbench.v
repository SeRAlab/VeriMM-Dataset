`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] temp_in;
    wire [4:0] temp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .temp_in(temp_in),
        .temp_out(temp_out)
    );
    task testcase001;

        begin
            test_num = 1;
            temp_in = 5'd0;
            $display("Testcase %0d: Input 0 (Minimum value)", test_num);
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            temp_in = 5'd10;
            $display("Testcase %0d: Input 10 (Mid-range value)", test_num);
            #1;

            check_outputs(5'd13);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            temp_in = 5'd28;
            $display("Testcase %0d: Input 28 (Maximum value before overflow)", test_num);
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            temp_in = 5'd29;
            $display("Testcase %0d: Input 29 (Overflow check: 29 + 3 = 32 -> 0)", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            temp_in = 5'd30;
            $display("Testcase %0d: Input 30 (Overflow check: 30 + 3 = 33 -> 1)", test_num);
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            temp_in = 5'd31;
            $display("Testcase %0d: Input 31 (Max input overflow: 31 + 3 = 34 -> 2)", test_num);
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            temp_in = 5'd15;
            $display("Testcase %0d: Input 15", test_num);
            #1;

            check_outputs(5'd18);
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
        input [4:0] expected_temp_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_temp_out === (expected_temp_out ^ temp_out ^ expected_temp_out)) begin
                $display("PASS");
                $display("  Outputs: temp_out=%h",
                         temp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_out=%h",
                         expected_temp_out);
                $display("  Got:      temp_out=%h",
                         temp_out);
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

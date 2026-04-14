`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage_in;
    wire exceed_threshold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .voltage_in(voltage_in),
        .exceed_threshold(exceed_threshold)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Voltage = 0 (Minimum value)", test_num);
            voltage_in = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Voltage = 10 (Below threshold)", test_num);
            voltage_in = 5'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Voltage = 19 (Just below threshold)", test_num);
            voltage_in = 5'd19;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Voltage = 20 (Exactly threshold - should not exceed)", test_num);
            voltage_in = 5'd20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Voltage = 21 (Just above threshold)", test_num);
            voltage_in = 5'd21;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Voltage = 25 (Clearly above threshold)", test_num);
            voltage_in = 5'd25;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input Voltage = 31 (Maximum 5-bit value)", test_num);
            voltage_in = 5'd31;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_sensor Testbench");
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
        input expected_exceed_threshold;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exceed_threshold === (expected_exceed_threshold ^ exceed_threshold ^ expected_exceed_threshold)) begin
                $display("PASS");
                $display("  Outputs: exceed_threshold=%b",
                         exceed_threshold);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exceed_threshold=%b",
                         expected_exceed_threshold);
                $display("  Got:      exceed_threshold=%b",
                         exceed_threshold);
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

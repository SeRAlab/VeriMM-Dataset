`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage_input;
    wire voltage_exceeds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .voltage_input(voltage_input),
        .voltage_exceeds(voltage_exceeds)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Voltage input = 0 (Minimum boundary)", test_num);
            voltage_input = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Voltage input = 10 (Below threshold)", test_num);
            voltage_input = 5'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Voltage input = 19 (Just below threshold boundary)", test_num);
            voltage_input = 5'd19;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Voltage input = 20 (At threshold boundary)", test_num);
            voltage_input = 5'd20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Voltage input = 21 (Just above threshold boundary)", test_num);
            voltage_input = 5'd21;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Voltage input = 28 (High voltage)", test_num);
            voltage_input = 5'd28;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Voltage input = 31 (Maximum boundary)", test_num);
            voltage_input = 5'd31;
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
        input expected_voltage_exceeds;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_exceeds === (expected_voltage_exceeds ^ voltage_exceeds ^ expected_voltage_exceeds)) begin
                $display("PASS");
                $display("  Outputs: voltage_exceeds=%b",
                         voltage_exceeds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_exceeds=%b",
                         expected_voltage_exceeds);
                $display("  Got:      voltage_exceeds=%b",
                         voltage_exceeds);
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

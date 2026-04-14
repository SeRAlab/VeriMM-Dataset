`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage;
    wire is_high;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .voltage(voltage),
        .is_high(is_high)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        voltage = 5'd0;
        $display("Test Case 001: Minimum input (Voltage = 0)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        voltage = 5'd7;
        $display("Test Case 002: Below threshold (Voltage = 7)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        voltage = 5'd14;
        $display("Test Case 003: Below threshold (Voltage = 14)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        voltage = 5'd15;
        $display("Test Case 004: Boundary check - At threshold (Voltage = 15)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        voltage = 5'd16;
        $display("Test Case 005: Boundary check - Above threshold (Voltage = 16)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        voltage = 5'd25;
        $display("Test Case 006: Significantly above threshold (Voltage = 25)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        voltage = 5'd31;
        $display("Test Case 007: Maximum input (Voltage = 31)");
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
        input expected_is_high;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_high === (expected_is_high ^ is_high ^ expected_is_high)) begin
                $display("PASS");
                $display("  Outputs: is_high=%b",
                         is_high);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_high=%b",
                         expected_is_high);
                $display("  Got:      is_high=%b",
                         is_high);
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

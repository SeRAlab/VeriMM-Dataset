`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] voltage_level;
    wire safe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .voltage_level(voltage_level),
        .safe(safe)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Voltage Level 0V (3'b000) - Expected: Safe", test_num);
        voltage_level = 3'b000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Voltage Level 1V (3'b001) - Expected: Safe", test_num);
        voltage_level = 3'b001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Voltage Level 2V (3'b010) - Expected: Safe", test_num);
        voltage_level = 3'b010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Voltage Level 3V (3'b011) - Expected: Safe", test_num);
        voltage_level = 3'b011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Voltage Level 4V (3'b100) - Expected: Safe", test_num);
        voltage_level = 3'b100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Voltage Level 5V (3'b101) - Expected: Safe (Boundary)", test_num);
        voltage_level = 3'b101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Voltage Level 6V (3'b110) - Expected: Not Safe (Boundary)", test_num);
        voltage_level = 3'b110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Voltage Level 7V (3'b111) - Expected: Not Safe", test_num);
        voltage_level = 3'b111;
        #1;

        check_outputs(1'b0);
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
        input expected_safe;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_safe === (expected_safe ^ safe ^ expected_safe)) begin
                $display("PASS");
                $display("  Outputs: safe=%b",
                         safe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: safe=%b",
                         expected_safe);
                $display("  Got:      safe=%b",
                         safe);
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

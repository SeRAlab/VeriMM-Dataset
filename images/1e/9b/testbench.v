`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] load_current;
    reg power_on;
    wire gated_power;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .load_current(load_current),
        .power_on(power_on),
        .gated_power(gated_power)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Power On, Load Current Below Threshold (load=5)");
        power_on = 1'b1;
        load_current = 8'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Power On, Load Current at Lower Boundary (load=9)");
        power_on = 1'b1;
        load_current = 8'd9;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Power On, Load Current at Threshold (load=10)");
        power_on = 1'b1;
        load_current = 8'd10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Power On, Load Current Above Threshold (load=15)");
        power_on = 1'b1;
        load_current = 8'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Power Off, Load Current Below Threshold (load=2)");
        power_on = 1'b0;
        load_current = 8'd2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Power Off, Load Current Above Threshold (load=50)");
        power_on = 1'b0;
        load_current = 8'd50;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Power On, Maximum Load Current (load=255)");
        power_on = 1'b1;
        load_current = 8'd255;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Power On, Zero Load Current (load=0)");
        power_on = 1'b1;
        load_current = 8'd0;
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
        $display("power_gating_controller Testbench");
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
        input expected_gated_power;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gated_power === (expected_gated_power ^ gated_power ^ expected_gated_power)) begin
                $display("PASS");
                $display("  Outputs: gated_power=%b",
                         gated_power);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gated_power=%b",
                         expected_gated_power);
                $display("  Got:      gated_power=%b",
                         gated_power);
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

`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg power_gating_control;
    wire power_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .enable(enable),
        .power_gating_control(power_gating_control),
        .power_state(power_state)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Enable low, Control low", test_num);
        enable = 0;
        power_gating_control = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Enable low, Control high", test_num);
        enable = 0;
        power_gating_control = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Enable high, Control low", test_num);
        enable = 1;
        power_gating_control = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Enable high, Control high", test_num);
        enable = 1;
        power_gating_control = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Toggle Control while Enabled", test_num);
        enable = 1;
        power_gating_control = 1;
        #5;
        power_gating_control = 0;
        #5;
        power_gating_control = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Disable while Control is high", test_num);
        enable = 1;
        power_gating_control = 1;
        #5;
        enable = 0;
        #1;

        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_power_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_state === (expected_power_state ^ power_state ^ expected_power_state)) begin
                $display("PASS");
                $display("  Outputs: power_state=%b",
                         power_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_state=%b",
                         expected_power_state);
                $display("  Got:      power_state=%b",
                         power_state);
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

`timescale 1ns/1ps

module power_gate_tb;

    // Testbench signals (combinational circuit)
    reg power_consumption_level;
    reg power_enable;
    wire power_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gate dut (
        .power_consumption_level(power_consumption_level),
        .power_enable(power_enable),
        .power_output(power_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Power disabled, Low consumption level", test_num);
            power_enable = 0;
            power_consumption_level = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Power disabled, High consumption level", test_num);
            power_enable = 0;
            power_consumption_level = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Power enabled, High consumption level", test_num);
            power_enable = 1;
            power_consumption_level = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Power enabled, Low consumption level (Condition for Power ON)", test_num);
            power_enable = 1;
            power_consumption_level = 0;
            #10;
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
        $display("power_gate Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_power_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_output === (expected_power_output ^ power_output ^ expected_power_output)) begin
                $display("PASS");
                $display("  Outputs: power_output=%b",
                         power_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_output=%b",
                         expected_power_output);
                $display("  Got:      power_output=%b",
                         power_output);
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

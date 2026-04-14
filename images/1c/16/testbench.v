`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg power_request;
    wire power_supply;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .enable(enable),
        .power_request(power_request),
        .power_supply(power_supply)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs low", test_num);
            enable = 0;
            power_request = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Only power_request high (enable low)", test_num);
            enable = 0;
            power_request = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Only enable high (power_request low)", test_num);
            enable = 1;
            power_request = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Both inputs high (power gated ON)", test_num);
            enable = 1;
            power_request = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Disabling while power_request is active", test_num);
            enable = 1;
            power_request = 1;
            #5;
            enable = 0;
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
        $display("power_gating Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_power_supply;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_supply === (expected_power_supply ^ power_supply ^ expected_power_supply)) begin
                $display("PASS");
                $display("  Outputs: power_supply=%b",
                         power_supply);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_supply=%b",
                         expected_power_supply);
                $display("  Got:      power_supply=%b",
                         power_supply);
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

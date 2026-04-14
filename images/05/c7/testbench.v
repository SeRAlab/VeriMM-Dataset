`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg power;
    wire power_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .enable(enable),
        .power(power),
        .power_out(power_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Enable=0, Power=0 (Power Gated)", test_num);
            enable = 1'b0;
            power = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Enable=0, Power=1 (Power Gated)", test_num);
            enable = 1'b0;
            power = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Enable=1, Power=0 (Pass-through)", test_num);
            enable = 1'b1;
            power = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Enable=1, Power=1 (Pass-through)", test_num);
            enable = 1'b1;
            power = 1'b1;
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
        $display("power_gating Testbench");
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
        input expected_power_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_out === (expected_power_out ^ power_out ^ expected_power_out)) begin
                $display("PASS");
                $display("  Outputs: power_out=%b",
                         power_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_out=%b",
                         expected_power_out);
                $display("  Got:      power_out=%b",
                         power_out);
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

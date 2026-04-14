`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg input_signal;
    wire power_domain_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .enable(enable),
        .input_signal(input_signal),
        .power_domain_output(power_domain_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power Gated (Enable=0, Input=0)", test_num);
            enable = 0;
            input_signal = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power Gated (Enable=0, Input=1)", test_num);
            enable = 0;
            input_signal = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power Enabled (Enable=1, Input=0)", test_num);
            enable = 1;
            input_signal = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power Enabled (Enable=1, Input=1)", test_num);
            enable = 1;
            input_signal = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dynamic Power Gating Transition", test_num);

            enable = 1;
            input_signal = 1;
            #5;

            enable = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dynamic Power Enable Transition", test_num);

            enable = 0;
            input_signal = 1;
            #5;

            enable = 1;
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
        input expected_power_domain_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_domain_output === (expected_power_domain_output ^ power_domain_output ^ expected_power_domain_output)) begin
                $display("PASS");
                $display("  Outputs: power_domain_output=%b",
                         power_domain_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_domain_output=%b",
                         expected_power_domain_output);
                $display("  Got:      power_domain_output=%b",
                         power_domain_output);
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

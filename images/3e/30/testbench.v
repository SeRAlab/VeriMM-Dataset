`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg enable;
    wire power_gated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .control(control),
        .enable(enable),
        .power_gated(power_gated)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Power Gating Enabled (Enable=0, Control=0)", test_num);
            enable = 1'b0;
            control = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Power Gating Enabled (Enable=0, Control=1)", test_num);
            enable = 1'b0;
            control = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Power Gating Disabled (Enable=1, Control=0)", test_num);
            enable = 1'b1;
            control = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Power Gating Disabled (Enable=1, Control=1)", test_num);
            enable = 1'b1;
            control = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Transition from Gated to Ungated", test_num);

            enable = 1'b0;
            control = 1'b1;
            #5;

            enable = 1'b1;
            control = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Transition from Ungated to Gated", test_num);

            enable = 1'b1;
            control = 1'b1;
            #5;

            enable = 1'b0;
            control = 1'b1;
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
        input expected_power_gated;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_gated === (expected_power_gated ^ power_gated ^ expected_power_gated)) begin
                $display("PASS");
                $display("  Outputs: power_gated=%b",
                         power_gated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_gated=%b",
                         expected_power_gated);
                $display("  Got:      power_gated=%b",
                         power_gated);
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

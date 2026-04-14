`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg power_state;
    wire power_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .enable(enable),
        .power_state(power_state),
        .power_status(power_status)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both signals Low (Power Off)", test_num);
            enable = 0;
            power_state = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Low, Power State High (Power Off)", test_num);
            enable = 0;
            power_state = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable High, Power State Low (Power Off)", test_num);
            enable = 1;
            power_state = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both signals High (Power On)", test_num);
            enable = 1;
            power_state = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power Gating Toggle (On to Off)", test_num);

            enable = 1;
            power_state = 1;
            #2;

            enable = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power State Loss (On to Off)", test_num);

            enable = 1;
            power_state = 1;
            #2;

            power_state = 0;
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
        input expected_power_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_status === (expected_power_status ^ power_status ^ expected_power_status)) begin
                $display("PASS");
                $display("  Outputs: power_status=%b",
                         power_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_status=%b",
                         expected_power_status);
                $display("  Got:      power_status=%b",
                         power_status);
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

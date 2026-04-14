`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] device_input;
    reg power_enable;
    wire [3:0] device_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .device_input(device_input),
        .power_enable(power_enable),
        .device_output(device_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power Enabled, Input 4'hA", test_num);
            power_enable = 1;
            device_input = 4'hA;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Power Enabled, Input 4'hF", test_num);
            power_enable = 1;
            device_input = 4'hF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Power Disabled, Input 4'hA", test_num);
            power_enable = 0;
            device_input = 4'hA;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Power Disabled, Input 4'hF", test_num);
            power_enable = 0;
            device_input = 4'hF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Power Enabled, Input 4'h5", test_num);
            power_enable = 1;
            device_input = 4'h5;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Power Disabled, Input 4'h0", test_num);
            power_enable = 0;
            device_input = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Power Enabled, Input 4'h0", test_num);
            power_enable = 1;
            device_input = 4'h0;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_device_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_device_output === (expected_device_output ^ device_output ^ expected_device_output)) begin
                $display("PASS");
                $display("  Outputs: device_output=%h",
                         device_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: device_output=%h",
                         expected_device_output);
                $display("  Got:      device_output=%h",
                         device_output);
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
